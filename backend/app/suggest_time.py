from .models import Schedules, Assignments, ToDoLists, GroupTags
import datetime
import copy
import numpy as np
from itertools import chain

class SuggestTime:
    def __init__(self, request):
        print(request)
        print(request.get("to_do_list"))
        to_do_list = ToDoLists.objects.get(id=request.get("to_do_list"))
        self.my_user_id = to_do_list.user
        if to_do_list.collaborating_member:
            self_collabo_id_list = [to_do_list.collaborating_member]
        elif to_do_list.collaborating_group:
            self.collabo_id_list = [tag.user for tag in GroupTags.objects.filter(groupname=to_do_list.collaborating_group)]
        else:
            self.collabo_id_list = []
        self.required_time = datetime.timedelta(hours=to_do_list.estimated_work_time.hour, minutes=to_do_list.estimated_work_time.minute)
        self.required_time_minute = self.required_time.total_seconds() // 60

        if self.required_time_minute >= 60*4:
            self.assignment_count = self.required_time_minute // (60*2)
            self.required_time_minute = self.required_time_minute // self.assignment_count
        else:
            self.assignment_count = 1
        self.limit_date = to_do_list.limited_time
    
    def helloworld(self):
        return "helloworld"

    def __calc_list_number(self, minute):
        return int((60 / minute) * 24)
    
    def __minute2hhmmss(self, minute):
        h = int(minute // 60)
        m = int(minute - h * 60)
        s = round((minute - (int(minute - h * 60) + h * 60)) * 60)
        return ("00" + str(h))[-2:] + ":" + ("00" + str(m))[-2:] + ":" + ("00" + str(s))[-2:]

    def __get_user_schedule(self, user_id, date):
        return list(chain(Schedules.objects.filter(user_id=user_id, start_time__date=date), Assignments.objects.filter(user_id=user_id, start_time__date=date)))
    
    def __create_time_dict(self):
        time_dict = {}
        countminute = 0
        counter = 0
        four_hour_count = 0
        nine_hour_count = 0
        eighteen_hour_count = 0

        while countminute < 60*24:
            time_dict[counter] = self.__minute2hhmmss(countminute)
            if countminute >= 60*9 and not nine_hour_count:
                nine_hour_count = counter
            if countminute >= 60*16 and not four_hour_count:
                four_hour_count = counter
            if countminute >= 60*18 and not eighteen_hour_count:
                eighteen_hour_count = counter
            countminute += self.required_time_minute
            counter += 1
        priority_time_indexes = [i if i >= 0 else -i for i in range(-four_hour_count, counter-four_hour_count)]
        priority_time_indexes = [-1 for _ in range(nine_hour_count)] + priority_time_indexes[nine_hour_count:eighteen_hour_count+1] + [-1 for _ in range(counter - eighteen_hour_count -1)]

        return time_dict, priority_time_indexes

    def get_suggest_time(self):
        return_data = []
        all_user_ids = copy.copy(self.collabo_id_list)
        all_user_ids.append(self.my_user_id)

        time_dict, priority_time_indexes = self.__create_time_dict()

        for day in range((self.limit_date - datetime.datetime.now(datetime.timezone(datetime.timedelta(hours=9), "JST"))).days + 1):
            date = (datetime.datetime.now() + datetime.timedelta(days=day)).date()
            for user_id in all_user_ids:
                user_schedules = self.__get_user_schedule(user_id, date)
                all_user_time_list = np.array([0 for _ in range(self.__calc_list_number(self.required_time_minute))])
                sum_time_list = np.array([0 for _ in range(self.__calc_list_number(self.required_time_minute))])
                for schedule in user_schedules:
                    time_list = np.array([0 for _ in range(self.__calc_list_number(self.required_time_minute))])

                    schedule.start_time = schedule.start_time + datetime.timedelta(hours=9)
                    if hasattr(schedule, "margin"):
                        print(schedule.margin.hour)
                        margin_time = datetime.timedelta(hours=schedule.margin.hour, minutes=schedule.margin.minute, seconds=schedule.margin.second)
                        schedule.end_time = schedule.end_time + datetime.timedelta(hours=9) + margin_time
                    else:
                        schedule.end_time = schedule.end_time + datetime.timedelta(hours=9)

                    start = schedule.start_time.hour * 60 + ((schedule.start_time.minute // self.required_time_minute) * self.required_time_minute) + (((schedule.start_time.second / 60) // (self.required_time_minute * 60)) * self.required_time_minute * 60)
                    end = schedule.end_time.hour * 60 + ((schedule.end_time.minute // self.required_time_minute) * self.required_time_minute) + (((schedule.end_time.second / 60) // (self.required_time_minute * 60)) * self.required_time_minute * 60)

                    count_minute = 0
                    counter = 0
                    while count_minute < 60*24:
                        if start <= count_minute and count_minute <= end:
                            time_list[counter] = 1
                        count_minute += self.required_time_minute
                        counter += 1
                    sum_time_list += np.array(time_list)
                all_user_time_list += sum_time_list

            for ind in range(max(priority_time_indexes)+1):
                time_indexes = [i for i, x in enumerate(priority_time_indexes) if x == ind]
                for i in time_indexes:
                    schedule_dict = {}
                    if all_user_time_list[i] == 0:
                        schedule_dict["start_time"] = datetime.datetime.combine(date, datetime.datetime.strptime(time_dict[i], "%H:%M:%S").time())
                        schedule_dict["end_time"] = schedule_dict["start_time"] + datetime.timedelta(minutes=self.required_time_minute)
                        return_data.append(schedule_dict)
        return return_data, self.assignment_count
