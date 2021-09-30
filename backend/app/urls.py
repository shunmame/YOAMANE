# coding: utf-8

from rest_framework import routers
from .views import *


router = routers.DefaultRouter()
router.register(r'user', UserViewSet)
router.register(r'schedule', ScheduleViewSet)
router.register(r'friend', FriendViewSet)
router.register(r'assignment', AssignmentViewSet)
router.register(r'timetabletime', TimeTableTimeViewSet)
router.register(r'grouptag', GroupTagViewSet)
router.register(r'timetable', TimeTableViewSet)
router.register(r'todolist', ToDoListViewSet)
router.register(r'todolisttask', ToDoListTaskViewSet)
router.register(r'subject', SubjectViewSet)
router.register(r'color', ColorViewSet)
