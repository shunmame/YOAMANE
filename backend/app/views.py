from rest_framework import viewsets
from rest_framework.views import APIView
from rest_framework.response import Response

from .models import *
from .serializer import *
from .common_schedule import CommonSchedule
from .suggest_time import SuggestTime
from .ridge_regression import RidgeRegression 

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
        assignments = Assignments.objects.filter(user=request.GET.get("user"), start_time__date=request.GET.get("date"))
        serializer = AssignmentSerializer(assignments, many=True)
        return Response(serializer.data)

class TimeTableTimeViewSet(viewsets.ModelViewSet):
    queryset = TimeTableTimes.objects.all()
    serializer_class = TimeTableTimeSerializer
    filter_fields = ['user',]

class GroupNameViewSet(viewsets.ModelViewSet):
    queryset = GroupNames.objects.all()
    serializer_class = GroupNameSerializer
    filter_fields = ['create_user']

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

class SuggestTimeAPIView(APIView):
    def get(self, request, format=None):
        suggest_time = SuggestTime(request.GET)
        suggest_times, count = suggest_time.get_suggest_time()
        print(suggest_times)
        return Response({
            "data" : request.GET,
            "count" : count,
            "candidate" : suggest_times,
            })

class MarginAPIView(APIView):
    def get(self, request, format=None):
        ridge_reg = RidgeRegression(request.POST)
        y = ridge_reg.get_margin_time()
        return Response({
            "message" : "hoge",
            "y" : y
            })

class ReportTime(APIView):
    def post(self, request, format=None):
        assignment = Assignments.objects.get(id=request.POST.get("id"))
        assignment.complete_time = request.POST.get("complete_time")
        assignment.is_finished = True
        assignment.save()
        return Response({
            "message" : "ok"
            })

class ShareTimeTable(APIView):
    def post(self, request, format=None):
        time_table = TimeTables.objects.filter(user=request.POST.get("from_user")).first()
        time_table.pk = None
        time_table.user = Users.objects.get(id=request.POST.get("to_user"))
        time_table.save()
        return Response({
            "message" : "OK"
            })
        
