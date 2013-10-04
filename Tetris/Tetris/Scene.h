//
//  Scene.h
//  Tetris
//
//  Created by cody on 9/9/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Tetris__Scene__
#define __Tetris__Scene__

#import "./TexturedNode.h"
#include "./GameField.h"
#include "./NextController.h"
#include "./InfoPanel.h"
#include "./Button.h"
#include <memory>
#include <functional>
#include <map>

///
class Scene
	: public TexturedNode
{
public:
	Scene(const CGSize& size);
	bool HandleTap(const CGPoint& point) override;

	void Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix) override;
	GameField& GameFieldRef() { return *gameField_; }
	void ButtonPressed(Btn btn);
	void SetTrigger(Btn btn, std::function<void()> trigger);

private:
	std::shared_ptr<NextController> nextController_;
	std::shared_ptr<GameField> gameField_;
	std::shared_ptr<InfoPanel> infoPanel_;
	std::map<Btn, std::function<void()>> triggers_;
};

#endif /* defined(__Tetris__Scene__) */
