import os
import platform
import pytest
import retro
import tempfile
import urllib.request
import validators

from datetime import datetime
from os.path import exists
from pathlib import Path

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
    environment = retro.make(game='SonicTheHedgehog-Genesis', state='GreenHillZone.Act1')

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
    agent.learn(total_timesteps=int(os.getenv('TOTAL_TIMESTEPS', '1000')))

    # Then
    filename = f'sonic_agent_for_{game}_on_state_{state}_{datetime.now().strftime('%Y-%m-%dT%H_%M_%SZ')}'
    filename = filename.replace('.', '_')
    filename = f'{filename}.agent'
    agent.save(filename)

    assert exists(filename)


@pytest.mark.test_sonic_agent
def test_sonic_agent(game=os.getenv('SONIC_GAME'), state=os.getenv('SONIC_STATE'),
                     agent_file=os.getenv('SONIC_AGENT_FILE')):
    # Given
    assert agent_file

    path, filename = os.path.split(agent_file)
    path = Path('/tmp' if platform.system() == 'Darwin' else tempfile.gettempdir())
    file = f'{path}/{filename}'

    if validators.url(agent_file):
        urllib.request.urlretrieve(agent_file, file)

    file = f'{path}/{filename}'

    environment = DummyVecEnv([lambda: retro.make(game=game, state=state)])
    environment = VecNormalize(environment, norm_obs=True, norm_reward=False, clip_obs=10.)
    agent = PPO.load(path=file, env=environment, verbose=1)

    # When
    dictionary_result = main(environment, agent)

    # Then
    assert dictionary_result
    assert dictionary_result['time'] > 0

    minimum_expected_score = int(os.getenv('MINIMUM_EXPECTED_SCORE', '0'))
    maximum_expected_score = int(os.getenv('MAXIMUM_EXPECTED_SCORE', '0'))

    assert minimum_expected_score <= dictionary_result['total_reward'] < maximum_expected_score
