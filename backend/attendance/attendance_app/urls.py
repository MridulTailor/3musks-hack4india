from django.urls import path
from .views import AttendanceSessionView

urlpatterns = [
    path('attendance-session/', AttendanceSessionView.as_view(), name='attendance_session'),
]
