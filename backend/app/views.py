from rest_framework import viewsets
from rest_framework.views import APIView
from rest_framework.response import Response

from .models import *
from .serializer import *
from .common_schedule import CommonSchedule

class UserViewSet(viewsets.ModelViewSet):
    queryset = Users.objects.all()
    serializer_class = UserSerializer

class ScheduleViewSet(viewsets.ModelViewSet):
    queryset = Schedules.objects.all()
    serializer_class = ScheduleSerializer
    filter_fields = ['user',]

    def list(self, request):
        schedules = Schedules.objects.filter(user=request.GET.get("user"), start_time__date=request.GET.get("date"))
        serializer = ScheduleSerializer(schedules, many=True)
        return Response(serializer.data)

class FriendViewSet(viewsets.ModelViewSet):
    queryset = Friends.objects.all()
    serializer_class = FriendSerializer
    filter_fields = ['user',]

class AssignmentViewSet(viewsets.ModelViewSet):
    queryset = Assignments.objects.all()
    serializer_class = AssignmentSerializer
    filter_fields = ['user',]

    def list(self, request):
        assignments = Assignments.objects.filter(start_time__date=request.GET.get("date"))
        serializer = AssignmentSerializer(assignments, many=True)
        return Response(serializer.data)

class TimeTableTimeViewSet(viewsets.ModelViewSet):
    queryset = TimeTableTimes.objects.all()
    serializer_class = TimeTableTimeSerializer
    filter_fields = ['user',]

class GroupTagViewSet(viewsets.ModelViewSet):
    queryset = GroupTags.objects.all()
    serializer_class = GroupTagSerializer
    filter_fields = ['create_user',]

class TimeTableViewSet(viewsets.ModelViewSet):
    queryset = TimeTables.objects.all()
    serializer_class = TimeTableSerializer
    filter_fields = ['user',]

class ToDoListViewSet(viewsets.ModelViewSet):
    queryset = ToDoLists.objects.all()
    serializer_class = ToDoListSerializer
    filter_fields = ['user', 'subject_id']

class ToDoListTaskViewSet(viewsets.ModelViewSet):
    queryset = ToDoListTasks.objects.all()
    serializer_class = ToDoListTaskSerializer
    filter_fields = ['id', 'to_do_list_id']

class SubjectViewSet(viewsets.ModelViewSet):
    queryset = Subjects.objects.all()
    serializer_class = SubjectSerializer
    filter_fields = ['user',]

class ColorViewSet(viewsets.ModelViewSet):
    queryset = Colors.objects.all()
    serializer_class = ColorSerializer

class CommonScheduleAPIView(APIView):
    def get(self, request, format=None):
        common_schedule = CommonSchedule(request.POST)
        return Response({
            "data" : request.POST,
            "candidate" : common_schedule.get_common_schedule(),
        })