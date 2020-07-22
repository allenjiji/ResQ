from rest_framework import serializers
from flood.models import UserProfile,UserPost

class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model=UserProfile
        #fields=('email','phone','name','is_volunteer','password')
        fields='__all__'
        extra_kwargs={
            'password':{
                'write_only':True,
            }
        }
    
    def validate(self, attrs):
        if attrs['is_volunteer']:
            print("yes")
            if all(x in attrs.keys() for x in['address','district','areaofvol']):
                print("yes2")
                return attrs
            else:
                print("yes3")
                raise serializers.ValidationError("Data not sufficient to be Volunteer")
        else:
            return super().validate(attrs)

    def create(self, validated_data):
        print('etthi')
        #print(validated_data)
        user=UserProfile.objects.create_user(**validated_data)
        return user

class UserPostSerializer(serializers.ModelSerializer):
    class Meta:
        model =UserPost
        fields='__all__'
        #exclude=('upvotes',)
        extra_kwargs={
            'userprofile':{
                'read_only':True
            }
        }
