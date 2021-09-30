from rest_framework import serializers
from django.contrib.auth.hashers import make_password
import copy

from .models import *

from .insert_schedule_of_timetable import TimeTableSchedule

class UserSerializer(serializers.ModelSerializer):
    # user_id=serializers.UUIDField(
    #     read_only=True
    # )
    
    def validate_username(self,value):
        if len(value) > 50:
            raise serializers.ValidationError("The name has to be within 50 charactor")
        return value
    
    class Meta:
        model = Users
        fields = ('id', 'user_id', 'username', 'password')

    def create(self, validated_data):
        user = Users(
            username = validated_data["username"],
            password = make_password(validated_data["password"])
        )
        user.save()
        return user

    def update(self, instance, validated_data):
        instance.username = validated_data.get("username", instance.username)
        instance.password = make_password(validated_data.get("password", instance.password))
        instance.save()
        return instance


class GroupNameSerializer(serializers.ModelSerializer):
    def validate_name(self,value):
        if len(value) > 50:
            raise serializers.ValidationError("The name has to be within 50 charactor")
        return value

    class Meta:
        model = GroupNames
        fields = ('id','name')


class GroupTagSerializer(serializers.ModelSerializer):
    # user_id = UserSerializer()

    class Meta:
        model = GroupTags
        fields = ('id','user_id','groupname_id','create_user_id')


class ScheduleSerializer(serializers.ModelSerializer):
    # user_id = UserSerializer()
    # collaborating_group_id = GroupTagSerializer()
    # collaborating_member_id = UserSerializer()

    def validate_title(self,value):
        if len(value) > 50:
            raise serializers.ValidationError("The name has to be within 50 charactor")
        return value

    class Meta:
        model = Schedules
        fields = ('id', 'title', 'start_time', 'end_time', 'is_all_day', 'notifying_time', 'collaborating_member_id', 'collaborating_group_id', 'memo', 'user_id')


class FriendSerializer(serializers.ModelSerializer):
    user_info = UserSerializer(read_only=True)
    user = serializers.PrimaryKeyRelatedField(queryset=Users.objects.all())
    friend_user_info = UserSerializer(read_only=True)
    friend_user_id = serializers.CharField(write_only=True)

    class Meta:
        model = Friends
        fields = ('id', 'user', 'friend_user', 'friend_user_id', 'user_info', 'friend_user_info')

    def create(self, validated_data):
        friend_user = Users.objects.get(user_id__startswith=validated_data["friend_user_id"])
        validated_data["friend_user"] = friend_user
        del validated_data['friend_user_id']
        return Friends.objects.create(**validated_data)


class AssignmentSerializer(serializers.ModelSerializer):
    # user_id = UserSerializer()
    # collaborating_group_id = GroupTagSerializer()
    # collaborating_member_id = UserSerializer()

    class Meta:
        model = Assignments
        fields = ('id', 'name', 'start_time', 'is_finished', 'complete_time', 'required_time', 'notifying_time', 'collaborating_member_id', 'collaborating_group_id', 'memo', 'user_id')


class TimeTableTimeSerializer(serializers.ModelSerializer):
    # user = UserSerializer()

    class Meta:
        model = TimeTableTimes
        fields = ('id', 'start_time', 'class_time', 'break_time', 'lunch_break_start_time', 'lunch_break_end_time', 'user')

    def create(self, validated_data):
        time_table = TimeTables.objects.filter(user=validated_data["user"])
        if time_table:
            time_table_schedule = TimeTableSchedule(copy.copy(validated_data), time_table)
            schedules = time_table_schedule.get_class_schedule()
            Schedules.objects.bulk_create(schedules)
        time_table_time = TimeTableTimes(**validated_data)
        time_table_time.save()
        return time_table_time

    def update(self, instance, validated_data):
        time_table = TimeTables.objects.filter(user=validated_data["user"])
        if time_table:
            time_table_schedule = TimeTableSchedule(copy.copy(validated_data), time_table)
            schedules = time_table_schedule.update_class_schedule()
            Schedules.objects.bulk_update(schedules, fields=["title", "start_time", "end_time"])
        
        instance.start_time = validated_data.get("start_time", instance.start_time)
        instance.class_time = validated_data.get("class_time", instance.class_time)
        instance.break_time = validated_data.get("break_time", instance.break_time)
        instance.lunch_break_start_time = validated_data.get("lunch_break_start_time", instance.lunch_break_start_time)
        instance.lunch_break_end_time = validated_data.get("lunch_break_end_time", instance.lunch_break_end_time)
        instance.save()
        return instance

class TimeTableSerializer(serializers.ModelSerializer):
    # user = UserSerializer()

    class Meta:
        model = TimeTables
        fields = ('id', 'monday_timetable', 'tuesday_timetable', 'wednesday_timetable', 'thursday_timetable', 'friday_timetable', 'saturday_timetable', 'sunday_timetable', 'user')
    
    def create(self, validated_data):
        time_table_time = TimeTableTimes.objects.filter(user=validated_data["user"])
        if time_table_time:
            time_table_schedule = TimeTableSchedule(time_table_time, copy.copy(validated_data))
            schedules = time_table_schedule.get_class_schedule()
            Schedules.objects.bulk_create(schedules)
        time_table = TimeTables(**validated_data)
        time_table.save()
        return time_table

    def update(self, instance, validated_data):
        time_table_time = TimeTableTimes.objects.filter(user=validated_data["user"])
        if time_table_time:
            time_table_schedule = TimeTableSchedule(time_table_time, copy.copy(validated_data))
            schedules = time_table_schedule.update_class_schedule()
            Schedules.objects.bulk_update(schedules, fields=["title", "start_time", "end_time"])
        
        instance.monday_timetable = validated_data.get('monday_timetable', instance.monday_timetable)
        instance.tuesday_timetable = validated_data.get('tuesday_timetable', instance.tuesday_timetable)
        instance.wednesday_timetable = validated_data.get('wednesday_timetable', instance.wednesday_timetable)
        instance.thursday_timetable = validated_data.get('thursday_timetable', instance.thursday_timetable)
        instance.friday_timetable = validated_data.get('friday_timetable', instance.friday_timetable)
        instance.saturday_timetable = validated_data.get('saturday_timetable', instance.saturday_timetable)
        instance.sunday_timetable = validated_data.get('sunday_timetable', instance.sunday_timetable)
        instance.save()
        return instance

class ToDoListSerializer(serializers.ModelSerializer):
    # user_id = UserSerializer()
    # subjects_id = SubjectSerializer()

    def validate_name(self,value):
        if len(value) > 50:
            raise serializers.ValidationError("The name has to be within 50 charactor")
        return value

    class Meta:
        model = ToDoLists
        fields = ('id', 'name', 'subject_id', 'limited_time', 'estimated_work_time', 'notifying_time', 'collaborating_member_id', 'collaborating_group_id', 'memo', 'is_work_finished', 'user_id')


class ToDoListTaskSerializer(serializers.ModelSerializer):
    # to_do_list_id = ToDoListSerializer()

    def validate_name(self,value):
        if len(value) > 50:
            raise serializers.ValidationError("The name has to be within 50 charactor")
        return value

    class Meta:
        model = ToDoListTasks
        fields = ('id', 'to_do_list_id', 'name', 'is_work_finished')


class ColorSerializer(serializers.ModelSerializer):
    def validate_name(self,value):
        if len(value) > 50:
            raise serializers.ValidationError("The name has to be within 50 charactor")
        return value

    def validate_red(self,value):
        if value > 255 or value<0:
            raise serializers.ValidationError("The value has to be within 255 - 0")
        return value

    def validate_green(self,value):
        if value > 255 or value<0:
            raise serializers.ValidationError("The value has to be within 255 - 0")
        return value

    def validate_blue(self,value):
        if value > 255 or value<0:
            raise serializers.ValidationError("The value has to be within 255 - 0")
        return value

    class Meta:
        model = Colors
        fields = ('id', 'name', 'red', 'green', 'blue')


class SubjectSerializer(serializers.ModelSerializer):
    # user_id = UserSerializer()
    # color_id = ColorSerializer()

    def validate_name(self,value):
        if len(value) > 50:
            raise serializers.ValidationError("The name has to be within 50 charactor")
        return value
    
    class Meta:
        model = Subjects
        fields = ('id', 'name', 'is_hidden', 'user_id', 'color_id')
