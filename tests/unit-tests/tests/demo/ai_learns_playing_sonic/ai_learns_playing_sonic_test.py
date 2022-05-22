from demo.ai_learns_playing_sonic.ai_learns_playing_sonic import about_to_play_sonic, main


def test_about_to_play_sonic():
    # When & then
    assert about_to_play_sonic() == 'You rock Sonic!'


def test_ai_to_learn_to_play_sonic():
    # When
    dictionary_result = main()

    # Then
    assert dictionary_result
    assert dictionary_result['time'] > 0
    assert dictionary_result['total_reward'] > 0
