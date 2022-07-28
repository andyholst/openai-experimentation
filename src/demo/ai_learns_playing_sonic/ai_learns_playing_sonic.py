import retro
import numpy as np


def about_to_play_sonic():
    return 'You rock Sonic!'


def main(environment=None, agent=None, verbose=False):
    about_to_play_sonic()
    if not environment:
        environment = retro.make(game='SonicTheHedgehog-Genesis', state='GreenHillZone.Act1')
    observation = environment.reset()
    time = 0
    total_reward = 0
    info_content = None
    while True:
        if agent:
            action, _states = agent.predict(observation, deterministic=True)
        else:
            action = environment.action_space.sample()

        observation, reward, done, info = environment.step(action)
        environment.render()

        time += 1
        if time % 10 == 0 and info:
            info_content = set_info_content(agent, info)
            if verbose:
                print(f'time={time}, info: {info_content}')
                print(f'total_reward={total_reward}')

        if type(reward).__module__ == np.__name__:
            total_reward += reward.item()
        else:
            total_reward += reward
        if reward > 0 and verbose:
            print(f'time: {time}, reward: {reward}, current_reward: {total_reward}')
        if reward < 0 and verbose:
            print(f'time: {time}, penalty: {reward}, current_reward: {total_reward}')
        if done:
            # This happens both, when time and lives are up, and when game is completed
            environment.render()
            if verbose:
                print('done!')
            break
    if verbose:
        print(f'time: {time}, total_reward: {total_reward}, info: {info_content}')
    environment.close()
    return {'time': time, 'total_reward': total_reward, 'info': info_content}


def set_info_content(agent, info):
    if not agent:
        info_content = {key: value for key, value in info.items()}
    else:
        info_content = info
    return info_content


if __name__ == '__main__':
    print(about_to_play_sonic())
    main()
