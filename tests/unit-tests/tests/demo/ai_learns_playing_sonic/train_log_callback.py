import os
from datetime import datetime

from stable_baselines3.common.callbacks import BaseCallback


class TrainLogCallback(BaseCallback):
    def __init__(self, check_freq, save_path, filename, verbose=1):
        super(TrainLogCallback, self).__init__(verbose)

        self.check_freq = check_freq
        self.save_path = save_path
        self.filename = filename

    def _init_callback(self):
        if self.save_path is not None:
            os.makedirs(self.save_path, exist_ok=True)

    def _on_step(self):
        if self.n_calls % self.check_freq == 0:
            save_filename = f'{self.filename}_{datetime.now().strftime("%Y-%m-%dT%H_%M_%SZ")}'
            save_filename = f'{save_filename}.agent'
            save_agent_filepath = os.path.join(self.save_path, save_filename)
            self.model.save(save_agent_filepath)

        return True
