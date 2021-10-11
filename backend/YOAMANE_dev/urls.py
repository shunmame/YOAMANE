"""YOAMANE_dev URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.conf.urls import url, include

from app.urls import router as app_router
from app.views import *

from rest_framework_swagger.views import get_swagger_view
from rest_framework_jwt.views import obtain_jwt_token, refresh_jwt_token, verify_jwt_token

schema_view = get_swagger_view(title="API Lists")

urlpatterns = [
    #path('admin/', admin.site.urls)
    url(r'^admin/', admin.site.urls),
    url(r'^api/', include(app_router.urls)),
    url(r'^doc/', schema_view),
    url(r'^api-token-auth/', obtain_jwt_token),
    url(r'^api-token-refresh/', refresh_jwt_token),
    url(r'^api-token-verify/', verify_jwt_token),
    url(r'^api/common-schedule/', CommonScheduleAPIView.as_view()),
    url(r'^api/suggest-time/', SuggestTimeAPIView.as_view()),
    url(r'^api/margin/', MarginAPIView.as_view()),
    url(r'^api/report/', ReportTime.as_view()),
    url(r'^api/share-timetable', ShareTimeTable.as_view()),
]
