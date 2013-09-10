//
//  TetrisViewController.m
//  Tetris
//
//  Created by cody on 9/5/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#import "TetrisViewController.h"
#import "ShaderProgram.h"
#import "Scene.h"

@interface TetrisViewController()
{
	GLuint program_;
	ShaderProgram shaderProgram_;
	Scene* scene_;
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

	//NSLog(@"%f x %f", self.view.bounds.size.width, self.view.bounds.size.height);
	CGSize windowSize = CGSizeMake(self.view.bounds.size.height, self.view.bounds.size.width); // Album orientation
	shaderProgram_.projectionMatrix = GLKMatrix4MakeOrtho(0, windowSize.width, 0, windowSize.height, -1024, 1024);
	scene_ = new Scene(windowSize, shaderProgram_);

	[self setupGL];
}

///
- (void)dealloc
{    
    [self tearDownGL];

	delete scene_;
    
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

	scene_->RenderWithModelViewMatrix(GLKMatrix4Identity);
}

///
- (void)update
{
	scene_->Update(self.timeSinceLastUpdate);
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
    shaderProgram_.uniforms.mvpMatrix = glGetUniformLocation(program_, "modelViewProjectionMatrix");
	shaderProgram_.uniforms.texSampler = glGetUniformLocation(program_, "texSampler");
	shaderProgram_.uniforms.color = glGetUniformLocation(program_, "color");
    
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
