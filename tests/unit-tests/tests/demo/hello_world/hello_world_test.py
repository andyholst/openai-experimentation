from demo.ai_learns_playing_sonic.ai_learns_playing_sonic import main, print_main


def test_main():
    assert main() == 'Hello world!'


def test_name():
    assert print_main() is None
