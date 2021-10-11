from sklearn.kernel_ridge import KernelRidge
import pandas as pd
import datetime
import numpy as np

from .models import Assignments, ToDoLists

class RidgeRegression:
    def __init__(self, assignment):
        self.request = assignment
        self.clr = KernelRidge(alpha=0.1, degree=3, kernel='poly')
        self.assignments = Assignments.objects.filter(is_finished=True, user=assignment["user"])
        self.to_do_lists = ToDoLists.objects.all()
        self.train_list = []
        self.__create_train_data()

    def __create_X_test(self, assignment):
        X_test = []
        X_test.append(assignment["to_do_list"].subject_id)
        X_test.append(assignment["start_time"].weekday())
        required_time = assignment["required_time"]
        X_test.append((datetime.timedelta(hours=required_time.hour, minutes=required_time.minute, seconds=required_time.minute).total_seconds() - self.df["required_time_second"].mean()) / self.df["required_time_second"].std())
        return np.array(X_test)

    def __create_train_data(self):
        for assignment in self.assignments:
            train_dict = {}
            train_dict["subject_id"] = self.to_do_lists.get(id=assignment.to_do_list.id).subject_id
            train_dict["start_weekday"] = assignment.start_time.weekday()
            train_dict["required_time_second"] = datetime.timedelta(hours=assignment.required_time.hour, minutes=assignment.required_time.minute, seconds=assignment.required_time.second).total_seconds()
            #train_dict["margin_second"] = assignment["margin"].total_seconds()
            train_dict["y"] = (assignment.complete_time - assignment.start_time).total_seconds()
            self.train_list.append(train_dict)
        print(self.train_list)

    def get_margin_time(self):
        self.df = pd.DataFrame(self.train_list)
        train_df = self.df.copy()
        train_df["subject_id"] = self.df["subject_id"]
        train_df["start_weekday"] = self.df["start_weekday"]
        train_df["required_time_second"] = (self.df["required_time_second"] - self.df["required_time_second"].mean()) / self.df["required_time_second"].std()
        train_df["y"] = (self.df["y"] - self.df["y"].mean()) / self.df["y"].std()
        
        X = train_df.iloc[:, :-1].values
        Y = train_df.iloc[:, -1:].values
        self.clr.fit(X, Y)

        X_test = self.__create_X_test(self.request)
        print(X_test)
        y = self.clr.predict([X_test])

        return y * self.df["required_time_second"].std() + self.df["required_time_second"].mean()

