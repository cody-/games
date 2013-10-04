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

///
class Game
{
public:
	Game(GameField& gameField);
	void Update(float dt);

	void MoveLeft();
	void MoveRight();
	void MoveDown();
	void Rotate();

	void SetTouchdownCallback(std::function<void()> cb) { touchdownCallback_ = cb; }

private:
	void PerformActions();
	void SetSpeed(float speed);
	void TouchDown();

	GameField& gameField_;

	std::function<void()> touchdownCallback_;

	std::vector<std::function<void()>> actions_;
	std::mutex actionsAccess_;

	float timeSinceLastMoveDown_;
	float speed_;  // cells per second
	float movePeriodSec_;

	bool touchdown_;
};

#endif /* defined(__Tetris__Game__) */
