from django.contrib import admin

from .models import *

@admin.register(Users)
class User(admin.ModelAdmin):
    pass

@admin.register(Schedules)
class Schedule(admin.ModelAdmin):
    pass

@admin.register(Assignments)
class Assignment(admin.ModelAdmin):
    pass

@admin.register(GroupNames)
class GroupName(admin.ModelAdmin):
    pass

@admin.register(GroupTags)
class GroupTag(admin.ModelAdmin):
    pass

@admin.register(ToDoLists)
class ToDoList(admin.ModelAdmin):
    pass

@admin.register(TimeTables)
class Timetable(admin.ModelAdmin):
    pass

@admin.register(Friends)
class Friend(admin.ModelAdmin):
    pass

@admin.register(Colors)
class Color(admin.ModelAdmin):
    pass

@admin.register(ToDoListTasks)
class ToDoListTask(admin.ModelAdmin):
    pass

@admin.register(Subjects)
class Subject(admin.ModelAdmin):
    pass

@admin.register(TimeTableTimes)
class TimetableTimes(admin.ModelAdmin):
    pass
