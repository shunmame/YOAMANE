import datetime
import jpholiday
import json
import warnings

from .models import Schedules, Subjects, Users

warnings.simplefilter('ignore')

class TimeTableSchedule:
    def __init__(self, time_table_time, time_table):
        self.user_id = 0
        if not isinstance(time_table_time, dict):
            self.time_table_times = time_table_time.values()[0]
            self.user_id = Users.objects.get(id=self.time_table_times["user_id"])
        else:
            self.time_table_times = time_table_time

        if not isinstance(time_table, dict):
            self.time_tables = time_table.values()[0]
            self.user_id = Users.objects.get(id=self.time_tables["user_id"])
        else:
            self.time_tables = time_table

    def __isBizDay(self, Date):
        if Date.weekday() >= 5 or jpholiday.is_holiday(Date):
            return 0
        else:
            return 1
        
    def __calc_class_time(self):
        class_times = []
        counter = -1
        is_after_lunch = False

        self.time_table_times["start_time"] = datetime.datetime.combine(datetime.date.today(), self.time_table_times["start_time"])
        self.time_table_times["class_time"] = datetime.timedelta(hours=self.time_table_times["class_time"].hour, minutes=self.time_table_times["class_time"].minute)
        self.time_table_times["break_time"] = datetime.timedelta(hours=self.time_table_times["break_time"].hour, minutes=self.time_table_times["break_time"].minute)
        self.time_table_times["lunch_break_start_time"] = datetime.datetime.combine(datetime.date.today(), self.time_table_times["lunch_break_start_time"])
        self.time_table_times["lunch_break_end_time"] = datetime.datetime.combine(datetime.date.today(), self.time_table_times["lunch_break_end_time"])

        while len(class_times) <= 5:
            counter += 1
            class_time = {}
            if counter == 0:
                start_time = self.time_table_times["start_time"]
            else :
                start_time = end_time + self.time_table_times["break_time"]
            if self.time_table_times["lunch_break_start_time"] <= start_time and start_time < self.time_table_times["lunch_break_end_time"] and not is_after_lunch:
                is_after_lunch = True
                continue
            if is_after_lunch:
                start_time = self.time_table_times["lunch_break_end_time"]
                is_after_lunch = False
            end_time = start_time + self.time_table_times["class_time"]
            class_time["start_time"] = start_time.time()
            class_time["end_time"] = end_time.time()
            class_times.append(class_time)

        return class_times
    
    def get_class_schedule(self):
        week_days = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
        class_times = self.__calc_class_time()
        
        schedules = []
        start_day = (datetime.datetime.now() + datetime.timedelta(hours=9)).date()
        end_day = datetime.datetime(2021, 12, 31).date()

        for delta_day in range((end_day - start_day).days + 1):
            date = start_day + datetime.timedelta(days=delta_day)
            if self.__isBizDay(date):
                time_table = json.loads(self.time_tables[week_days[date.weekday()] + "_timetable"])

                for key, class_time in zip(time_table, class_times):
                    schedule = Schedules(
                        title = Subjects.objects.get(pk=time_table[key]).name,
                        start_time = datetime.datetime.combine(date, class_time["start_time"]),
                        end_time = datetime.datetime.combine(date, class_time["end_time"]),
                        is_all_day = False,
                        notifying_time = None,
                        collaborating_member = None,
                        collaborating_group = None,
                        memo = None,
                        user = self.user_id,
                        is_class = True
                    )
                    schedules.append(schedule)
        return schedules

    def update_class_schedule(self):
        week_days = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
        dict_keys = ["first", "second", "third", "fourth", "fifth"]
        schedules = []
        date = False
        counter = 0

        class_times = self.__calc_class_time()

        for schedule in Schedules.objects.filter(user=self.user_id, is_class=True):
            if not date:
                date = schedule.start_time.date()
            else:
                if date != schedule.start_time.date():
                    date = schedule.start_time.date()
                    counter = 0
            time_table = json.loads(self.time_tables[week_days[schedule.start_time.weekday()] + "_timetable"])
            if not len(time_table):
                continue
            try:
                schedule.title = Subjects.objects.get(pk=time_table[dict_keys[counter]]).name
                schedule.start_time = datetime.datetime.combine(schedule.start_time.date(), class_times[counter]["start_time"])
                schedule.end_time = datetime.datetime.combine(schedule.start_time.date(), class_times[counter]["end_time"])
            except KeyError:
                schedule.delete()
            schedules.append(schedule)

            counter += 1

        return schedules
