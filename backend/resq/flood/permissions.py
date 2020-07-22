from rest_framework import permissions

class UserProfilePermission(permissions.BasePermission):
    def has_object_permission(self, request, view, obj):
        if request.method in permissions.SAFE_METHODS:
            return True
        else:
            return request.user==obj.id
        

class UserPostPermission(permissions.BasePermission):
    def has_object_permission(self, request, view, obj):
        if request.method=='PATCH' and len(request.body)==1 and 'upvotes' in request.body.keys():
            return True
        elif request.method in permissions.SAFE_METHODS:
            return True
        else:
            return request.user==obj.userprofile
