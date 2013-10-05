//
//  Scene.mm
//  Tetris
//
//  Created by cody on 9/9/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./Scene.h"
#include "./GameField.h"
#include "./Button.h"
#include "./Square.h"

using namespace std;

///
Scene::Scene(const CGSize& size)
	: TexturedNode("bg-tech.jpg", size)
{
	contentSize_ = size;

	CGFloat btnY = size.height*2/3;
	CGFloat btnOffsetX = 30;
	CGFloat btnRadius = 40;

	CGFloat offset = 3*btnOffsetX + 4*btnRadius;

	nextController_ = make_shared<NextController>(USize{4U, 4U});
	children_.push_back(nextController_);

	gameField_ = shared_ptr<GameField>(new GameField(size.height, [&]() { return nextController_->NextFigure(); }));
	children_.push_back(gameField_);

	gameField_->SetPosition(CGPointMake(offset, 0));

	CGFloat nearGameField = offset + gameField_->ContentSize().width + Square::SIDE;
	nextController_->SetPosition({nearGameField, contentSize_.height - nextController_->ContentSize().height - Square::SIDE});

	children_.push_back(unique_ptr<Node>(new Button("gear.png", btnRadius, {size.width - (btnOffsetX + 2*btnRadius), size.height - (btnOffsetX + 2*btnRadius)}, [&]{ ButtonPressed(Btn::SETTINGS); })));
	children_.push_back(unique_ptr<Node>(new Button("rotate-ccw.png", btnRadius, {size.width - (btnOffsetX + 2*btnRadius), btnY}, [&]{ ButtonPressed(Btn::ROTATE); })));
	children_.push_back(unique_ptr<Node>(new Button("arrow left.png", btnRadius, {btnOffsetX, btnY}, [&]{ ButtonPressed(Btn::LEFT); })));
	children_.push_back(unique_ptr<Node>(new Button("arrow right.png", btnRadius, {2*btnOffsetX + 2*btnRadius, btnY}, [&]{ ButtonPressed(Btn::RIGHT); })));
	children_.push_back(unique_ptr<Node>(new Button("arrow down.png", btnRadius, {btnOffsetX*1.5f + btnRadius, btnY - 2*btnRadius}, [&]{ ButtonPressed(Btn::DOWN); })));

	infoPanel_ = make_shared<InfoPanel>();
	CGFloat infoPanelPosY = contentSize_.height - nextController_->ContentSize().height - 2*Square::SIDE - infoPanel_->ContentSize().height;
	infoPanel_->SetPosition({nearGameField, infoPanelPosY});
	children_.push_back(infoPanel_);

	settingsPanel_ = make_shared<SettingsPanel>(CGSize{contentSize_.width - nearGameField, infoPanelPosY - Square::SIDE});
	settingsPanel_->SetPosition({nearGameField, 0});
	children_.push_back(settingsPanel_);
}

///
bool Scene::HandleTap(const CGPoint& point)
{
	for (const auto& child : children_)
	{
		if (child->HandleTap(point))
			break;
	}

	return true;
}

///
void Scene::Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix)
{
	glUniform1i(program.uniforms.useColor, 0);

	TexturedNode::Render(program, modelViewMatrix);
}

///
void Scene::ButtonPressed(const Btn btn)
{
	try {
		triggers_.at(btn)();
	}
	catch(const out_of_range&) {}
}

///
void Scene::SetTrigger(Btn btn, function<void()> trigger)
{
	triggers_[btn] = trigger;
}
