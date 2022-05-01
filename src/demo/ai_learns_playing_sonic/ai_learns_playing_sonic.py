import retro


def about_to_play_sonic():
    return "You rock Sonic!"


def main():
    about_to_play_sonic()
    env = retro.make(game="SonicTheHedgehog-Genesis", state="GreenHillZone.Act1")
    obs = env.reset()
    while True:
        obs, rew, done, info = env.step(env.action_space.sample())
        env.render()
        if done:
            obs = env.reset()
    env.close()


if __name__ == "__main__":
    about_to_play_sonic()
