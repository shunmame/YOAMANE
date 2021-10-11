import pymc3 as pm
import numpy as np
import datetime
import random
# import asyncio

from .models import Assignments

class BayesianInference():
    def __init__(self, user_id):
        self.start_times = np.array([start_time["start_time"] + datetime.timedelta(hours=9) for start_time in Assignments.objects.filter(user=user_id, is_finished=True).values("start_time")])
        self.end_times = np.array([end_time["end_time"] + datetime.timedelta(hours=9) for end_time in Assignments.objects.filter(user=user_id, is_finished=True).values("end_time")])
        self.complete_times =np.array([complete_time["complete_time"] + datetime.timedelta(hours=9) for complete_time in  Assignments.objects.filter(user=user_id, is_finished=True).values("complete_time")])
        self.delta_times = [absdeltatime.seconds*-1 if deltatime.days < 0 else absdeltatime.seconds for absdeltatime, deltatime in zip(abs(self.complete_times - self.end_times), (self.complete_times - self.end_times))]
        print(self.start_times)
        print(self.end_times)
        print(self.complete_times)
        print(self.delta_times)
    
    # def __learning(self):
    #     with pm.Model() as model:
    #         delta_time = pm.Normal("delta_time", mu=0, sigma=100)
    #         y = pm.Normal("y", mu=delta_time, observed=self.delta_times)

    #     with model:
    #         trace = pm.sample(1500)

    #     return pm.find_MAP(model=model)
    #     # return pm.summary(np.array(self.delta_times))["mean"]["x"]
    
    # async def calc_mean(self):
    #     _learning = asyncio.create_task(self.__learning())
    #     mean = await _learning
    #     return mean
    
    def calc_mean(self):
        return pm.summary(np.array(self.delta_times))["mean"]["x"]