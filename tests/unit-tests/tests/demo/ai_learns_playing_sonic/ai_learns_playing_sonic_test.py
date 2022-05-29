import retro
from demo.ai_learns_playing_sonic.ai_learns_playing_sonic import about_to_play_sonic, main
from stable_baselines3 import PPO
from stable_baselines3.common.vec_env import DummyVecEnv, VecNormalize


def test_about_to_play_sonic():
    # When & then
    assert about_to_play_sonic() == 'You rock Sonic!'


def test_ai_to_play_the_sonic_game():
    # Given
    environment = retro.make(game="SonicTheHedgehog-Genesis", state="GreenHillZone.Act1")

    # When
    dictionary_result = main(environment=environment)

    # Then
    assert dictionary_result
    assert dictionary_result['time'] > 0
    assert 100 < dictionary_result['total_reward'] <= 300


def test_train_ai_to_be_better_at_playing_the_sonic_game():
    # Given
    environment = DummyVecEnv([lambda: retro.make(game="SonicTheHedgehog-Genesis", state="GreenHillZone.Act1")])
    environment = VecNormalize(environment, norm_obs=True, norm_reward=False, clip_obs=10.)

    agent = PPO(policy='MlpPolicy', env=environment, verbose=1)
    agent.learn(total_timesteps=1000)

    # When
    dictionary_result = main(environment, agent)

    # Then
    assert dictionary_result
    assert dictionary_result['time'] > 0
    assert 0 <= dictionary_result['total_reward'] < 10000
