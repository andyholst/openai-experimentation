from demo.hello_world.hello_world import main, print_main


def test_main():
    assert main() == 'Hello world!'


def test_name():
    assert print_main() is not None
