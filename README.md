# Runtime Android Permission (unofficial patch for version 10.2.3)
  Runtime Android Permission for Firemonkey

<img style="display: block; margin-left: auto; margin-right: auto;" src="https://github.com/CarlosHe/AndroidPermission/blob/master/Screenshot_20180608-123523_Package%20installer.jpg" width="250"/>

# Bugs
  <b>For all bugs fixed, you must re-download and apply the patch again</b>
  
  - SOLVED - 2018-09-08
     * Unit 'FMX.SpellChecker.Android' not found.

# Requirements
  
  Android SDK latest possible.
  
  Delphi 10.2.3 (not tested in other version, but if you want to test, backup the files)

# Instalation:

  Download zip file: https://drive.google.com/file/d/1YqFnN6I2DwGmrpjlEbG4Wcvis4g3LFiX/view?usp=sharing

  Extract zip, copy "lib" and "source" folder into "Embarcadero\Studio\19.0" and replace all files.

# Usage:

  In your project, go to Project Options -> Uses Permissions, set suitable permissions.

  Example: go to Project Options -> Uses Permissions and set Read Contacts.

  Open "AndroidManifest.template.xml" inside the folder of your project and set android:minSdkVersion="14" and android:targetSdkVersion="26".
  
  Set Release mode on Build Configurations. (In Debug mode will not appear the permission box, only in Release mode)

``` xml
  <uses-sdk android:minSdkVersion="14" android:targetSdkVersion="26" />
````

``` pascal

uses FMX.Permissions.Android, Androidapi.JNIBridge, Androidapi.JNI.JavaTypes, Androidapi.JNI.GraphicsContentViewText;

type
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure RequestPermissionReadContacts;
    procedure PermissionCallback(AAndroidPermission: TAndroidPermission; APermissions: TJavaObjectArray<JString>; AGrantResults: TJavaArray<Integer>);
  public
    { Public declarations }
  end;

...
//Set the callback
procedure TForm1.FormCreate(Sender: TObject);
begin
  AndroidPermissions.onRequestPermissionsResult:=PermissionCallback;
end;

//Callback
procedure TForm1.PermissionCallback(AAndroidPermission: TAndroidPermission; APermissions: TJavaObjectArray<JString>;
  AGrantResults: TJavaArray<Integer>);
begin
  case AAndroidPermission of
    apREAD_CONTACTS:
    begin
      // If request is cancelled, the result arrays are empty.
      if (AGrantResults.Length > 0 ) and (AGrantResults[0]=TJPackageManager.JavaClass.PERMISSION_GRANTED) then
      begin
        // permission was granted, yay! Do the
        // contacts-related task you need to do.
      end
      else
      begin
        // permission denied, boo! Disable the
        // functionality that depends on this permission
      end;

    end;
    // other 'case' lines to check for other
    // permissions this app might request
  end;
end;

//Request permission read contacts
procedure TForm1.RequestPermissionReadContacts;
begin
  if (AndroidPermissions.checkSelfPermission(apREAD_CONTACTS)<>TJPackageManager.JavaClass.PERMISSION_GRANTED ) then
  begin
    // Should we show an explanation?
    if (AndroidPermissions.shouldShowRequestPermissionRationale(apREAD_CONTACTS)) then
    begin
      // Show an expanation to the user *asynchronously* -- don't block
      // this thread waiting for the user's response! After the user
      // sees the explanation, try again to request the permission.
    end
    else
    begin
      // No explanation needed, we can request the permission.
      AndroidPermissions.requestPermissions(apREAD_CONTACTS);
    end;

  end;
end;


````

# Bonus:

file:// scheme is now not allowed to be attached with Intent on targetSdkVersion 24 (Android Nougat). And here is the solution.

It is quite easy to implement FileProvider on your application. First you need to add a FileProvider <provider> tag in AndroidManifest.xml under <application> tag like below:
  
After paste, change the value of "android: authorities", putting the name of your package instead of <b>com.company.test</b>.
Example: <b>com.company.test</b>.fileprovider

``` xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    ...
    <application>
        ...
        <provider
          android:name="android.support.v4.content.FileProvider"
          android:authorities="your.package.name.fileprovider"
          android:exported="false"
          android:grantUriPermissions="true">
            <meta-data
              android:name="android.support.FILE_PROVIDER_PATHS"
              android:resource="@xml/provider_paths"/>
        </provider>
    </application>
</manifest>
````
Download "provider_paths.xml" file on "extra" folder and extract file and paste in your project folder.

Now, go to Deployment ( Project->Deployment ) and add "provider_paths.xml" file and set "remote path" to "res\xml\"

Ready! Have a good time...

