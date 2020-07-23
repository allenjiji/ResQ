from rest_framework import permissions

class UserProfilePermission(permissions.BasePermission):
    def has_object_permission(self, request, view, obj):
        print('hey')
        if request.method in permissions.SAFE_METHODS:
            return True
        else:
            print(request.user)
            print(obj.id)
            return request.user.id==obj.id
        

class UserPostPermission(permissions.BasePermission):
    def has_object_permission(self, request, view, obj):
        if request.method in permissions.SAFE_METHODS:
            print('hello')
            return True
        else:
            return request.user==obj.userprofile
