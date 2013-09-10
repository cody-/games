//
//  ShaderProgram.mm
//  Tetris
//
//  Created by cody on 9/10/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./ShaderProgram.h"

///
ShaderProgram::ShaderProgram()
	: handle(0)
{
}

///
ShaderProgram::~ShaderProgram()
{
	NSLog(@"Shader program destructor");
	if (handle)
	{
        glDeleteProgram(handle);
        handle = 0;
    }
}

///
void ShaderProgram::Use()
{
	glUseProgram(handle);
}

///
bool ShaderProgram::LoadShaders()
{
    GLuint vertShader, fragShader;
    NSString *vertShaderPathname, *fragShaderPathname;
    
    // Create shader program.
    handle = glCreateProgram();
    
    // Create and compile vertex shader.
    vertShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"vsh"];
    if (!CompileShader(&vertShader, GL_VERTEX_SHADER, vertShaderPathname)) {
        NSLog(@"Failed to compile vertex shader");
        return NO;
    }
    
    // Create and compile fragment shader.
    fragShaderPathname = [[NSBundle mainBundle] pathForResource:@"Shader" ofType:@"fsh"];
    if (!CompileShader(&fragShader, GL_FRAGMENT_SHADER, fragShaderPathname)) {
        NSLog(@"Failed to compile fragment shader");
        return NO;
    }
    
    // Attach vertex shader to program.
    glAttachShader(handle, vertShader);
    
    // Attach fragment shader to program.
    glAttachShader(handle, fragShader);
    
    // Bind attribute locations.
    // This needs to be done prior to linking.
    glBindAttribLocation(handle, GLKVertexAttribPosition, "position");
	glBindAttribLocation(handle, GLKVertexAttribTexCoord0, "texCoord");
    
    // Link program.
    if (!LinkProgram(handle)) {
        NSLog(@"Failed to link program: %d", handle);
        
        if (vertShader) {
            glDeleteShader(vertShader);
            vertShader = 0;
        }
        if (fragShader) {
            glDeleteShader(fragShader);
            fragShader = 0;
        }
        if (handle) {
            glDeleteProgram(handle);
            handle = 0;
        }
        
        return NO;
    }
    
    // Get uniform locations.
    uniforms.mvpMatrix = glGetUniformLocation(handle, "modelViewProjectionMatrix");
	uniforms.texSampler = glGetUniformLocation(handle, "texSampler");
	uniforms.color = glGetUniformLocation(handle, "color");
    
    // Release vertex and fragment shaders.
    if (vertShader) {
        glDetachShader(handle, vertShader);
        glDeleteShader(vertShader);
    }
    if (fragShader) {
        glDetachShader(handle, fragShader);
        glDeleteShader(fragShader);
    }
    
    return YES;
}

///
bool ShaderProgram::CompileShader(GLuint* shader, GLenum type, NSString* file)
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

///
bool ShaderProgram::LinkProgram(GLuint prog)
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

///
bool ShaderProgram::ValidateProgram(GLuint prog)
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
