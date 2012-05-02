function step()
{
  Processing.getInstanceById('game').step();
}

function play()
{
  Processing.getInstanceById('game').play();
}

function stop()
{
  Processing.getInstanceById('game').stop();
}

function rand()
{
  Processing.getInstanceById('game').rand();
}

function cls()
{
  Processing.getInstanceById('game').clear();
}

function speed(spd)
{
  Processing.getInstanceById('game').speed(spd);
}

function size(x, y)
{
  Processing.getInstanceById('game').reset_board(x, y);
}

