//
//  Game.h
//  Tetris
//
//  Created by cody on 10/3/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Tetris__Game__
#define __Tetris__Game__

#include <vector>
#include <functional>
#include <mutex>

class GameField;
class InfoPanel;

///
class Game
{
public:
	Game(GameField& gameField, InfoPanel& infoPanel);
	void Update(float dt);

	void MoveLeft();
	void MoveRight();
	void MoveDown();
	void Rotate();

	void SetTouchdownCallback(std::function<void()> cb) { touchdownCallback_ = cb; }

private:
	void PerformActions();
	void SetSpeed(unsigned speedLevel);
	void TouchDown();
	void UpdateLines(unsigned diff);

	GameField& gameField_;
	InfoPanel& infoPanel_;

	std::function<void()> touchdownCallback_;

	std::vector<std::function<void()>> actions_;
	std::mutex actionsAccess_;

	float timeSinceLastMoveDown_;
	unsigned speedLevel_;
	float movePeriodSec_; // time to move through one cell

	bool touchdown_;
	unsigned linesCounter_;
};

#endif /* defined(__Tetris__Game__) */
