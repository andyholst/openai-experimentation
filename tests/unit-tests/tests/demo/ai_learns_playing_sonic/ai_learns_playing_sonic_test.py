import os

import pytest
import retro

from datetime import datetime
from os.path import exists

from demo.ai_learns_playing_sonic.ai_learns_playing_sonic import about_to_play_sonic, main
from stable_baselines3 import PPO
from stable_baselines3.common.vec_env import DummyVecEnv, VecNormalize


@pytest.mark.test_sonic_skills
def test_about_to_play_sonic():
    # When & then
    assert about_to_play_sonic() == 'You rock Sonic!'


@pytest.mark.test_sonic_skills
def test_ai_to_play_the_sonic_game():
    # Given
    environment = retro.make(game="SonicTheHedgehog-Genesis", state="GreenHillZone.Act1")

    # When
    dictionary_result = main(environment=environment)

    # Then
    assert dictionary_result
    assert dictionary_result['time'] > 0
    assert 100 < dictionary_result['total_reward'] <= 300


@pytest.mark.train_sonic_agent
def test_train_ai_to_be_better_at_playing_the_sonic_game(game=os.getenv('SONIC_GAME'), state=os.getenv('SONIC_STATE')):
    # Given
    assert game
    assert state

    environment = DummyVecEnv([lambda: retro.make(game=game, state=state)])
    environment = VecNormalize(environment, norm_obs=True, norm_reward=False, clip_obs=10.)

    agent = PPO(policy='MlpPolicy', env=environment, verbose=1)

    # When
    agent.learn(total_timesteps=1000)

    # Then
    filename = f'sonic_agent_for_{game}_on_state_{state}_{datetime.now().strftime("%Y-%m-%dT%H_%M_%SZ")}.agent'
    agent.save(filename)

    assert exists(filename)


@pytest.mark.test_sonic_agent
def test_sonic_agent(game='SonicTheHedgehog-Genesis', state='GreenHillZone.Act1', agent=None):
    # Given
    assert agent

    environment = DummyVecEnv([lambda: retro.make(game=game, state=state)])
    environment = VecNormalize(environment, norm_obs=True, norm_reward=False, clip_obs=10.)
    agent = PPO.load(path=agent, env=environment, verbose=1)

    # When
    dictionary_result = main(environment, agent)

    # Then
    assert dictionary_result
    assert dictionary_result['time'] > 0
    assert 0 <= dictionary_result['total_reward'] < 10000
