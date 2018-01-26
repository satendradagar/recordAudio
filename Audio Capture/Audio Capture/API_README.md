#  <#Title#>

- postLogin
@input
email: string
password: string
ios_token: string
@output
data: user
error : boolean
error_code: number (1: valid_failure, 2: internal error)
message: string for error

- postRegister
@input
firstname : string
lastname : string
username : string
email : string
password : string
@output
data: user
error : boolean
error_code: number (1: validate_failure, 2: internal error, 3: already exist)
message: string for error

- postGetUploads
@input
user_id: string
@output
data: data uploaded by user(JSON)
error : boolean
error_code: number (1: validate_failure, 2: internal error, 3: already exist)
message: string for error

- postGetInbox
@input
user_id: string
@output
data: message in user inbox(JSON)
error : boolean
error_code: number (1: validate_failure, 2: internal error, 3: already exist)
message: string for error

- postGetFavorite
@input
user_id: string
@output
data: favorited music for user(JSON)
error : boolean
error_code: number (1: validate_failure, 2: internal error, 3: already exist)
message: string for error

- postGetMenu
@input
user_id: string
@output
data:
demo_num : number(newly arriving counter)
inbox_num : number(inbox page)
upload_num : number(uploads page)
favorite_num : number(favorite page)
group_list :  list of group in left side menu(array)
error : boolean
error_code: number (1: validate_failure, 2: internal error, 3: already exist)
message: string for error

- postRemoveMusic
@input
user_id: string (receiving user)
type: string
uploads
inbox
favourite
music_id: string
@output
error : boolean
error_code: number (1: validate_failure, 2: internal error, 3: already exist)
message: string for error

- postGetGroupMusic
@input
group_id: string
@output
data: music item in particular group(Array)
error : boolean
error_code: number (1: validate_failure, 2: internal error, 3: already exist)
message: string for error

- postSetFavorite
@input
inbox_id: string
@output
result:
0: Toggle off
1: Toggle on


ec2-35-177-218-234.eu-west-2.compute.amazonaws.com/uploads/( file name )
//Backend
Route::match(['get', 'post'],'api/login','APIController@postLogin');
Route::match(['get', 'post'],'api/register','APIController@postRegister');
Route::match(['get', 'post'],'api/get-uploads','APIController@postGetUploads');
Route::match(['get', 'post'],'api/get-inbox','APIController@postGetInbox');
Route::match(['get', 'post'],'api/get-favourite','APIController@postGetFavourite');
Route::match(['get', 'post'],'api/get-menu','APIController@postGetMenu');
Route::match(['get', 'post'],'api/remove_music','APIController@postRemoveMusic');
Route::match(['get', 'post'],'api/get-group_music','APIController@postGetGroupMusic');
Route::match(['get', 'post'],'api/set-favorite','APIController@postSetFavorite');

admin@admin.com
password

