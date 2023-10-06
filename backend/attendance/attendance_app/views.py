

# from rest_framework.views import APIView
# from rest_framework.response import Response
# from rest_framework import status
# from .models import AttendanceSession, StudentData
# from django.utils import timezone

# class AttendanceSessionView(APIView):
#     def post(self, request, *args, **kwargs):
#         action = request.data.get('action')
        
#         if action == 'on':
#             # Create a new session
#             session = AttendanceSession.objects.create(start_time=timezone.now(), is_active=True)
#             return Response({'message': 'Session started', 'session_id': session.id}, status=status.HTTP_201_CREATED)
#         elif action == 'off':
#             # Turn off the active session
#             try:
#                 active_session = AttendanceSession.objects.get(is_active=True)
#                 active_session.is_active = False
#                 active_session.end_time = timezone.now()
#                 active_session.save()


#                 wifi_id = request.data.get('wifi_id')
#                 session_id = request.data.get('session_id')
#                 # print(wifi_id, session_id)

#                 active_students = StudentData.objects.get(wifi_id= wifi_id, session_id=session_id)
#                 # print(active_students)


#                 return Response({'message': 'Session turned off'}, status=status.HTTP_200_OK)
#             except AttendanceSession.DoesNotExist:
#                 return Response({'error': 'No active session found'}, status=status.HTTP_404_NOT_FOUND)
#             except AttendanceSession.MultipleObjectsReturned:
#                 # If multiple active sessions found (should not happen), turn off the first one and log a warning
#                 active_sessions = AttendanceSession.objects.filter(is_active=True)
#                 for session in active_sessions[1:]:
#                     session.is_active = False
#                     session.end_time = timezone.now()
#                     session.save()
#                 return Response({'message': 'Multiple sessions found. First session turned off.'}, status=status.HTTP_200_OK)
#         else:
#             # Store additional data in the database
#             username = request.data.get('username')
#             session_id = request.data.get('session_id')
#             wifi_id = request.data.get('wifi_id')
#             date = request.data.get('date')
#             checkIn = request.data.get('checkIn')

#             StudentData.objects.create(username=username, session_id=session_id, wifi_id=wifi_id,date = date, checkIn= checkIn)
#             return Response({'message': 'Additional data stored successfully'}, status=status.HTTP_201_CREATED)




# {
#     "action": "custom",
#     "username": "vacha",
#     "session_id": "1234",
#     "wifi_id": "abcde",
#     "date":"12/03/12",
#     "checkIn":"10:12"
# }





from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import AttendanceSession, StudentData
from django.utils import timezone

class AttendanceSessionView(APIView):
    def post(self, request, *args, **kwargs):
        action = request.data.get('action')
        
        if action == 'on':
            # Create a new session
            session = AttendanceSession.objects.create(start_time=timezone.now(), is_active=True)
            return Response({'message': 'Session started', 'session_id': session.id}, status=status.HTTP_201_CREATED)
        elif action == 'off':
            # Turn off the active session
            try:
                active_session = AttendanceSession.objects.get(is_active=True)
                active_session.is_active = False
                active_session.end_time = timezone.now()
                active_session.save()

                wifi_id = request.data.get('wifi_id')
                session_id = request.data.get('session_id')

                # Handle the case where multiple StudentData records are found
                active_students = StudentData.objects.filter(wifi_id=wifi_id, session_id=session_id)

                # Create a list of active students
                active_students_list = [{"username": student.username, "date":student.date, "checkIn":student.checkIn} for student in active_students]

                response_data = {'message': 'Session turned off', 'active_students': active_students_list}
                return Response(response_data, status=status.HTTP_200_OK)
            except AttendanceSession.DoesNotExist:
                return Response({'error': 'No active session found'}, status=status.HTTP_404_NOT_FOUND)
            except AttendanceSession.MultipleObjectsReturned:
                # If multiple active sessions found (should not happen), turn off the first one and log a warning
                active_sessions = AttendanceSession.objects.filter(is_active=True)
                for session in active_sessions[1:]:
                    session.is_active = False
                    session.end_time = timezone.now()
                    session.save()
                return Response({'message': 'Multiple sessions found. First session turned off.'}, status=status.HTTP_200_OK)
        else:
            # Store additional data in the database
            username = request.data.get('username')
            session_id = request.data.get('session_id')
            wifi_id = request.data.get('wifi_id')
            date = request.data.get('date')
            checkIn = request.data.get('checkIn')

            StudentData.objects.create(username=username, session_id=session_id, wifi_id=wifi_id, date=date, checkIn=checkIn)
            return Response({'message': 'Additional data stored successfully'}, status=status.HTTP_201_CREATED)

