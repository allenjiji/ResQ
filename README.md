# ResQ

A Socialy Responsible Flutter project.

## Under Development

# Documentation Coming Soon...

**API Documentation**

**Show User**
----
  Returns json data about a particular user

* **URL**

  resq/userprofile/:id

* **Method:**
  
    `GET`

*  **URL Params**

   **Required:**
 
   `id=[integer]`


* **Success Response:**
  
  * **Code:** 200
    **Content:** `{
    "id": 1,
    "last_login": null,
    "is_superuser": false,
    "phone": "7558097485",
    "name": "monet",
    "is_volunteer": true,
    "district": "ernakulam",
    "areaofvol": "medicine",
    "address": "saranghi",
    "lat": "73.254000",
    "lon": "10.987000",
    "groups": [],
    "user_permissions": []
}`
 
* **Error Response:**

  * **Code:** 404 NOT FOUND 
    **Content:** `{ detail : "Not found" }`

**Show All Users**
----
  Returns json data about all users

* **URL**

  resq/userprofile/

* **Method:**
  
    `GET`

*  **Query Params**
    **Optional:**
* `lat=[decimal]`
*  `lon=[decimal]`



* **Success Response:**
  
  * **Code:** 200
    **Content:** `[{
    "id": 1,
    "last_login": null,
    "is_superuser": false,
    "phone": "7558097485",
    "name": "monet",
    "is_volunteer": true,
    "district": "ernakulam",
    "areaofvol": "medicine",
    "address": "saranghi",
    "lat": "73.254000",
    "lon": "10.987000",
    "groups": [],
    "user_permissions": []
}]`
 
**Create a User**
----
  Creates a new user and returns json data about a particular user

* **URL**

  resq/userprofile/

* **Method:**
  
    `POST`
* **Data Params**

  {phone,name,is_volunteer,lat,lon}
  
* **Success Response:**
  
  * **Code:** 200
    **Content:** `{
    "id": 1,
    "last_login": null,
    "is_superuser": false,
    "phone": "7558097485",
    "name": "monet",
    "is_volunteer": true,
    "district": "ernakulam",
    "areaofvol": "medicine",
    "address": "saranghi",
    "lat": "73.254000",
    "lon": "10.987000",
    "groups": [],
    "user_permissions": []
}`
 
* **Error Response:**

  * **Code:** 400 BAD REQUEST 
    **Content:** `{
    "non_field_errors": [
        "Data not sufficient to be Volunteer"
    ]
}`



