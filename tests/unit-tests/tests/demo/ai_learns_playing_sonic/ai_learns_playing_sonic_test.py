from demo.ai_learns_playing_sonic.ai_learns_playing_sonic import main, ai_learns_playing_sonic

import retro

env = retro.make(game="SonicTheHedgehog-Genesis", state="GreenHillZone.Act1")


def test_main():
    assert main() == 'Hello Sonic, here I come!'


def test_name():
    assert ai_learns_playing_sonic() is None
