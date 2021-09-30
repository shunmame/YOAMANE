import uuid as uuid_lib
from django.db import models
from django.contrib.auth.models import AbstractBaseUser, PermissionsMixin
from django.contrib.auth.base_user import BaseUserManager

# Create your models here.

class UserManager(BaseUserManager):
    use_in_migrations = True

    def _create_user(self, username, password, **extra_fields):
        """
        Create and save a user with the given username,  and password.
        """
        if not username:
            raise ValueError('The given username must be set')
        username = self.model.normalize_username(username)
        user = self.model(username=username, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_user(self, username, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', False)
        extra_fields.setdefault('is_superuser', False)
        return self._create_user(username, password, **extra_fields)

    def create_superuser(self, username, password, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        if extra_fields.get('is_staff') is not True:
            raise ValueError('Superuser must have is_staff=True')
        if extra_fields.get('is_superuser') is not True:
            raise ValueError('Superuser must have is_superuser=True')
        return self._create_user(username, password, **extra_fields)

class Users(AbstractBaseUser, PermissionsMixin):
    user_id = models.UUIDField(default=uuid_lib.uuid4, editable=False)
    username = models.CharField(unique=True, max_length=50)
    password = models.CharField(max_length=200)
    is_staff = models.BooleanField("is_staff", default=False)
    is_active = models.BooleanField("is_active", default=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    objects = UserManager()
    USERNAME_FIELD = 'username'
    REQUIRED_FIELDS = []

    def __repr__(self):
        return "{}: {}".format(self.pk, self.username)
    
    __str__ = __repr__

class Colors(models.Model):
    name = models.CharField(max_length=50)
    red = models.IntegerField()
    green = models.IntegerField()
    blue = models.IntegerField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __repr__(self):
        return "{}: {}".format(self.pk, self.name)
    
    __str__ = __repr__

class Friends(models.Model):
    user = models.ForeignKey(Users, on_delete=models.CASCADE, related_name="my_id")
    friend_user = models.ForeignKey(Users, on_delete=models.CASCADE, related_name="friend_id")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class GroupNames(models.Model):
    name = models.CharField(max_length=50)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __repr__(self):
        return "{}: {}".format(self.pk, self.name)
    
    __str__ = __repr__

class GroupTags(models.Model):
    groupname = models.ForeignKey(GroupNames, on_delete=models.CASCADE)
    create_user = models.ForeignKey(Users, on_delete=models.CASCADE, related_name="create_user")
    user = models.ForeignKey(Users, on_delete=models.CASCADE,related_name="grouptag_user")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __repr__(self):
        return "{}: {}".format(self.pk, self.name)
    
    __str__ = __repr__

class Schedules(models.Model):
    title = models.CharField(max_length=50)
    start_time = models.DateTimeField(blank=True, null=True)
    end_time = models.DateTimeField(blank=True, null=True)
    is_all_day = models.BooleanField(blank=True, null=True)
    notifying_time = models.TimeField(blank=True, null=True)
    collaborating_member = models.ForeignKey(Users, on_delete=models.CASCADE, blank=True, null=True,related_name="schedule_member_id")
    collaborating_group = models.ForeignKey(GroupTags,on_delete=models.CASCADE, blank=True, null=True, related_name="schedule_group_id")
    memo = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    user = models.ForeignKey(Users, on_delete=models.CASCADE,related_name="schedule_user")
    is_class = models.BooleanField(blank=True, null=True)

    def __repr__(self):
        return "{}: {}".format(self.pk, self.title)
    
    __str__ = __repr__

class Subjects(models.Model):
    name = models.CharField(max_length=50)
    is_hidden = models.BooleanField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    user = models.ForeignKey(Users, on_delete=models.CASCADE)
    color = models.ForeignKey(Colors, on_delete=models.CASCADE)

    def __repr__(self):
        return "{}: {}".format(self.pk, self.name)
    
    __str__ = __repr__

class ToDoLists(models.Model):
    name = models.CharField(max_length=50)
    subject = models.ForeignKey(Subjects, on_delete=models.CASCADE)
    limited_time = models.DateTimeField()
    estimated_work_time = models.TimeField()
    notifying_time = models.TimeField(blank=True, null=True)
    collaborating_member = models.ForeignKey(Users, on_delete=models.CASCADE, blank=True, null=True, related_name="todolist_member_id")
    collaborating_group = models.ForeignKey(GroupTags, on_delete=models.CASCADE, blank=True, null=True, related_name="todolist_group_id")
    memo = models.TextField(blank=True, null=True)
    is_work_finished = models.BooleanField(blank=True, null=True)
    user = models.ForeignKey(Users, on_delete=models.CASCADE, related_name="todolist_user")
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __repr__(self):
        return "{}: {}".format(self.pk, self.name)
    
    __str__ = __repr__

class Assignments(models.Model):
    name = models.CharField(max_length=50)
    start_time = models.DateTimeField()
    end_time = models.DateTimeField()
    is_finished = models.BooleanField(blank=True, null=True)
    complete_time = models.DateTimeField(blank=True, null=True)
    required_time = models.TimeField()
    notifying_time = models.TimeField(blank=True, null=True)
    margin = models.TimeField(blank=True, null=True)
    collaborating_member = models.ForeignKey(Users, on_delete=models.CASCADE, blank=True, null=True, related_name="assignment_member_id")
    collaborating_group = models.ForeignKey(GroupTags, on_delete=models.CASCADE, blank=True, null=True, related_name="assignment_group_id")
    memo = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    user = models.ForeignKey(Users, on_delete=models.CASCADE)
    to_do_list = models.ForeignKey(ToDoLists, on_delete=models.CASCADE, related_name="assignment_user")

    def __repr__(self):
        return "{}: {}".format(self.pk, self.name)
    
    __str__ = __repr__

class TimeTables(models.Model):
    monday_timetable = models.TextField(blank=True, null=True)
    tuesday_timetable = models.TextField(blank=True, null=True)
    wednesday_timetable = models.TextField(blank=True, null=True)
    thursday_timetable = models.TextField(blank=True, null=True)
    friday_timetable = models.TextField(blank=True, null=True)
    saturday_timetable = models.TextField(blank=True, null=True)
    sunday_timetable = models.TextField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    user = models.ForeignKey(Users, on_delete=models.CASCADE)

class ToDoListTasks(models.Model):
    to_do_list = models.ForeignKey(ToDoLists, on_delete=models.CASCADE)
    name = models.CharField(max_length=50)
    is_work_finished = models.BooleanField(blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __repr__(self):
        return "{}: {}".format(self.pk, self.name)
    
    __str__ = __repr__

class TimeTableTimes(models.Model):
    user = models.ForeignKey(Users, on_delete=models.CASCADE)
    start_time = models.TimeField()
    class_time = models.TimeField()
    break_time = models.TimeField()
    lunch_break_start_time = models.TimeField()
    lunch_break_end_time = models.TimeField()
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
