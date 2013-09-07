//
//  TetrisViewController.m
//  Tetris
//
//  Created by cody on 9/5/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#import "TetrisViewController.h"

typedef struct
{
	CGPoint geometryVertex;
	CGPoint textureVertex;
} TexturedVertex;

typedef struct
{
	TexturedVertex bl;
	TexturedVertex br;
	TexturedVertex tl;
	TexturedVertex tr;
} TexturedQuad;

@interface TetrisViewController()
{
	GLuint program_;
	GLKMatrix4 mvpMatrix_;
	GLint uniformMvpMatrix_;
	GLint uniformTexture_;
	GLint uniformColor_;
	TexturedQuad quad_;
}

@property (strong, nonatomic) EAGLContext* context;
@property (strong) GLKTextureInfo* textureInfo;

- (void)setupGL;
- (void)tearDownGL;

- (BOOL)loadShaders;
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file;
- (BOOL)linkProgram:(GLuint)prog;
- (BOOL)validateProgram:(GLuint)prog;

@end

@implementation TetrisViewController

///
- (void)viewDidLoad
{
	self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
	if (!self.context)
	{
		NSLog(@"Failed to create ES context");
	}
	GLKView* view = (GLKView*)self.view;
	view.context = self.context;
	[EAGLContext setCurrentContext:self.context];

	// Load texture
	NSDictionary* options = @{GLKTextureLoaderOriginBottomLeft: @YES};
	NSError* error;
	self.textureInfo = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"black-square40" ofType:@"png"] options:options error:&error];
	if (self.textureInfo == nil)
	{
		NSLog(@"Error loading file: %@", [error localizedDescription]);
		return;
	}

	TexturedQuad newQuad;
	newQuad.bl.geometryVertex = CGPointMake(0, 0);
	newQuad.br.geometryVertex = CGPointMake(self.textureInfo.width, 0);
	newQuad.tl.geometryVertex = CGPointMake(0, self.textureInfo.height);
	newQuad.tr.geometryVertex = CGPointMake(self.textureInfo.width, self.textureInfo.height);

	newQuad.bl.textureVertex = CGPointMake(0, 0);
	newQuad.br.textureVertex = CGPointMake(1, 0);
	newQuad.tl.textureVertex = CGPointMake(0, 1);
	newQuad.tr.textureVertex = CGPointMake(1, 1);
	quad_ = newQuad;

	[self setupGL];
}

///
- (void)dealloc
{    
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

///
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }

    // Dispose of any resources that can be recreated.
}

///
- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    
    [self loadShaders];
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    
    if (program_)
	{
        glDeleteProgram(program_);
        program_ = 0;
    }
}

#pragma mark GLKView and GLKViewController delegates

///
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
	glClearColor(0, 1, 1, 1);
	glClear(GL_COLOR_BUFFER_BIT);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_BLEND);

	glUseProgram(program_);

	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, self.textureInfo.name);

	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
	

	long offset = (long)&quad_;
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void*)(offset + offsetof(TexturedVertex, geometryVertex)));
	glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void*)(offset + offsetof(TexturedVertex, textureVertex)));


	glUniformMatrix4fv(uniformMvpMatrix_, 1, NO, mvpMatrix_.m);
	glUniform1i(uniformTexture_, 0);
	glUniform4f(uniformColor_, 1.0, 0.0, 0.0, 1.0);

	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}

///
- (void)update
{
    GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, self.view.bounds.size.width, 0, self.view.bounds.size.height, -1024, 1024);

	GLKMatrix4 modelViewMatrix = GLKMatrix4Identity;
	modelViewMatrix = GLKMatrix4Translate(modelViewMatrix, self.view.bounds.size.width/2, self.view.bounds.size.height/2, 0);
	mvpMatrix_ = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
}

#pragma mark -  OpenGL ES 2 shader compilation

///
- (BOOL)loadShaders
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    program_ = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (![self compileShader:&vertShader type:GL_VERTEX_SHADER file:vertShaderPathname]) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (![self compileShader:&fragShader type:GL_FRAGMENT_SHADER file:fragShaderPathname]) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(program_, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(program_, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(program_, GLKVertexAttribPosition, "position");
	glBindAttribLocation(program_, GLKVertexAttribTexCoord0, "texCoord");
    
    // Link program.
    if (![self linkProgram:program_]) {
        NSLog(@"Failed to link program: %d", program_);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (program_) {
            glDeleteProgram(program_);
            program_ = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    uniformMvpMatrix_ = glGetUniformLocation(program_, "modelViewProjectionMatrix");
	uniformTexture_ = glGetUniformLocation(program_, "texture");
	uniformColor_ = glGetUniformLocation(program_, "color");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(program_, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(program_, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

///
- (BOOL)compileShader:(GLuint *)shader type:(GLenum)type file:(NSString *)file
{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile log:\n%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    
    return YES;
}

- (BOOL)linkProgram:(GLuint)prog
{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link log:\n%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}

- (BOOL)validateProgram:(GLuint)prog
{
    GLint logLength, status;
    
    glValidateProgram(prog);
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program validate log:\n%s", log);
        free(log);
    }
    
    glGetProgramiv(prog, GL_VALIDATE_STATUS, &status);
    if (status == 0) {
        return NO;
    }
    
    return YES;
}


@end
