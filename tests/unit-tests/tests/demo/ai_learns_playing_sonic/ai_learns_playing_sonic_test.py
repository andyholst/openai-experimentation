import json
import os
import platform
import pytest
import re
import retro
import tempfile
import urllib.request
import validators

from datetime import datetime
from os.path import exists
from pathlib import Path

from tests.demo.ai_learns_playing_sonic.train_log_callback import TrainLogCallback
from demo.ai_learns_playing_sonic.ai_learns_playing_sonic import about_to_play_sonic, main

from stable_baselines3 import (
    A2C,
    DDPG,
    DQN,
    PPO,
    SAC,
    TD3
)  # noqa: Needed for dynamic loading of reinforcement learning algorithm

from gym.wrappers import GrayScaleObservation
from stable_baselines3.common.vec_env import DummyVecEnv, VecFrameStack


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
    assert 100 <= dictionary_result['total_reward'] <= 300


@pytest.mark.train_sonic_agent
def test_train_ai_to_be_better_at_playing_the_sonic_game(game=os.getenv('SONIC_GAME'), state=os.getenv('SONIC_STATE')):
    # Given
    assert game
    assert state

    normalized_environment = json.loads(os.getenv("NORMALIZED_ENVIRONMENT").lower())
    environment = retro.make(game=game, state=state)

    if normalized_environment:
        environment = GrayScaleObservation(env=environment, keep_dim=True)
        environment = DummyVecEnv([lambda: environment])
        environment = VecFrameStack(venv=environment, n_stack=8, channels_order='last')

    klass = globals()[os.getenv('RL_ALGORITHM')]

    assert klass

    filename = f'sonic_agent_for_{game}_on_state_{state}_'

    if normalized_environment:
        filename += 'NORMALIZED_'

    filename += f'{os.getenv("RL_ALGORITHM")}_{os.getenv("RL_POLICY")}'
    filename = filename.replace('.', '_')

    checkpoint_dir = os.getenv('CHECKPOINT_DIR', './model/train/')
    log_dir = os.getenv('LOG_DIR', '/.model/logs/')

    agent_callback = TrainLogCallback(check_freq=10000, save_path=checkpoint_dir, filename=filename)

    agent = klass(
        policy=os.getenv('RL_POLICY'),
        tensorboard_log=log_dir,
        env=environment,
        verbose=1,
        learning_rate=0.000001,
        n_steps=2048)

    total_timesteps = os.getenv('TOTAL_TIMESTEPS')
    assert total_timesteps

    # When
    agent.learn(total_timesteps=int(total_timesteps), callback=agent_callback)

    # Then
    filename += f'_{datetime.now().strftime("%Y-%m-%dT%H_%M_%SZ")}'
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

    regexp_pattern = r'\w{1,}_(\w{1,})_(\w{1,})_[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}_[0-9]{2}_[0-9]{2}Z\.agent'

    matcher = re.search(regexp_pattern, filename)

    assert matcher

    environment = retro.make(game=game, state=state)

    if 'NORMALIZED' in filename:
        environment = GrayScaleObservation(env=environment, keep_dim=True)
        environment = DummyVecEnv([lambda: environment])
        environment = VecFrameStack(venv=environment, n_stack=8, channels_order='last')

    klass = globals()[matcher.group(1)]

    agent = klass.load(path=file, env=environment, verbose=1)

    # When
    dictionary_result = main(environment, agent)

    # Then
    assert dictionary_result
    assert dictionary_result['time'] > 0

    minimum_expected_score = int(os.getenv('MINIMUM_EXPECTED_SCORE', '0'))
    maximum_expected_score = int(os.getenv('MAXIMUM_EXPECTED_SCORE', '1000'))

    assert minimum_expected_score <= dictionary_result['total_reward'] <= maximum_expected_score
