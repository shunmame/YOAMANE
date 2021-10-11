from rest_framework import serializers
from django.contrib.auth.hashers import make_password
from rest_framework.response import Response
import copy
import datetime

from .models import *

from .insert_schedule_of_timetable import TimeTableSchedule
#from .bayesian_inference import BayesianInference
from .ridge_regression import RidgeRegression

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
        fields = ('id','name', 'create_user')


class GroupTagSerializer(serializers.ModelSerializer):
    # user_id = UserSerializer()
    name = serializers.CharField(required=False)
    user_ids = serializers.CharField(required=False)

    class Meta:
        model = GroupTags
        fields = ('id','user','groupname','create_user', 'name', 'user_ids')

    def create(self, validated_data):
        groupname_data = copy.copy(validated_data)
        del groupname_data["user_ids"]
        groupname = GroupNames.objects.create(**groupname_data)

        del validated_data["name"]
        user_ids = validated_data["user_ids"]
        del validated_data["user_ids"]
        group_tags = []
        for user_id in user_ids.split(","):
            group_tag = GroupTags(
                    groupname = groupname,
                    create_user = validated_data["create_user"],
                    user = Users.objects.get(id=int(user_id))
                    )
            group_tags.append(group_tag)
        return GroupTags.objects.bulk_create(group_tags)


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
        fields = ('id', 'title', 'start_time', 'end_time', 'is_all_day', 'notifying_time', 'collaborating_member_id', 'collaborating_group_id', 'memo', 'user')


class FriendSerializer(serializers.ModelSerializer):
    #user_info = UserSerializer(read_only=True)
    #user = serializers.PrimaryKeyRelatedField(queryset=Users.objects.all())
    #friend_user_info = UserSerializer(read_only=True)
    friend_user_id = serializers.CharField(write_only=True, required=False)

    class Meta:
        model = Friends
        fields = ('id', 'user', 'friend_user', 'friend_user_id') # , 'user_info', 'friend_user_info')

    def create(self, validated_data):
        try:
            friend_user = Users.objects.get(user_id__startswith=validated_data["friend_user_id"])
            validated_data["friend_user"] = friend_user
            del validated_data['friend_user_id']
            return Friends.objects.create(**validated_data)
        except Users.DoesNotExist:
            from rest_framework.exceptions import NotFound
            raise NotFound()


class AssignmentSerializer(serializers.ModelSerializer):
    # user_id = UserSerializer()
    # collaborating_group_id = GroupTagSerializer()
    # collaborating_member_id = UserSerializer()

    class Meta:
        model = Assignments
        fields = ('id', 'name', 'start_time', 'end_time', 'is_finished', 'complete_time', 'margin', 'required_time', 'notifying_time', 'collaborating_member', 'collaborating_group', 'memo', 'user', 'to_do_list')
    
    def create(self, validated_data):
        ridge_regressor = RidgeRegression(validated_data)
        #bayesian_inference = BayesianInference(2)
        y = ridge_regressor.get_margin_time()[0][0]
        if y < 0:
            validated_data["margin"] = datetime.time(hour=0)
        else :
            _hour = int(y // 3600)
            _min = int((y - _hour * 3600) // 60)
            _sec = int(y - _hour * 3600 - _min * 60)
            validated_data["margin"] = datetime.time(hour=_hour, minute=_min, second=_sec)

        if "collaborating_member" in validated_data:
            if validated_data["collaborating_member"]:
                collabo_validated_data = copy.copy(validated_data)
                collabo_validated_data["user"] = validated_data["collaborating_member"]
                collabo_validated_data["collaborating_member"] = validated_data["user"]
                Assignments.objects.create(**collabo_validated_data)

        if "collaborating_group" in validated_data:
            if validated_data["collaborating_group"]:
                user_ids = GroupTags.objects.filter(groupname=validated_data["collaborating_group"], create_user=validated_data["user"])
                for user_id in user_ids:
                    collabo_validated_data = copy.copy(validated_data)
                    collabo_validated_data["user"] = user_id.user
                    Assignments.objects.create(**collabo_validated_data)
        return Assignments.objects.create(**validated_data)


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
            Schedules.objects.bulk_create(schedules)
        
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
            Schedules.objects.bulk_create(schedules)
        
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
    collaborating_ids = serializers.CharField(write_only=True, required=False)

    def validate_name(self,value):
        if len(value) > 50:
            raise serializers.ValidationError("The name has to be within 50 charactor")
        return value

    class Meta:
        model = ToDoLists
        fields = ('id', 'name', 'subject_id', 'limited_time', 'estimated_work_time', 'notifying_time', 'collaborating_member_id', 'collaborating_group_id', 'collaborating_ids', 'memo', 'is_work_finished', 'user')

    def create(self, validated_data):
        if "collaborating_ids" in validated_data:
            if validated_data["collaborating_ids"]:
                user_ids = validated_data["collaborating_ids"].split(",")
                if len(user_ids) == 1:
                    existing_group_tag = GroupTags.objects.filter(create_user=validated_data["user"], groupname=user_ids[0])
                    print(existing_group_tag)
                    if existing_group_tag:
                        #print(existing_group_tag[0].groupname)
                        #print(GroupNames.objects.filter(id=existing_group_tag[0].groupname))
                        validated_data["collaborating_group_id"] = existing_group_tag[0].groupname.id
                    else:
                        validated_data["collaborating_member_id"] = Users.objects.get(id=user_ids[0])
                else:
                    user_names = []
                    for user_id in user_ids:
                        user_names.append(Users.objects.get(id=user_id).username)
                    group_name_data = {"name": ",".join(user_names), "create_user": validated_data["user"]}
                    group_name = GroupNames.objects.create(**group_name_data)

                    group_tags = []
                    for user_id in user_ids:
                        group_tag = GroupTags(
                            groupname = group_name,
                            create_user = validated_data["user"],
                            user = Users.objects.get(id=int(user_id)),
                            )
                        group_tags.append(group_tag)
                    GroupTags.objects.bulk_create(group_tags)
                    validated_data["collaborating_group_id"] = group_name.id
            del validated_data["collaborating_ids"]
        return ToDoLists.objects.create(**validated_data)


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
        fields = ('id', 'name', 'is_hidden', 'user', 'color')
