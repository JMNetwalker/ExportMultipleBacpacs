#Connectivity details User DB and master DB
$server= "localhost"
$user="sa"
$password="********"
$Folder="C:\SqlPackage\Files\"

#Function to connect to the database
Function GiveMeConnectionSource{ 
  for ($i=0; $i -lt 10; $i++)
  {
   try
    {
      $SQLConnection = New-Object System.Data.SqlClient.SqlConnection 
      $SQLConnection.ConnectionString = "Server="+$server+";Database=master"+";User ID="+$user+";Password="+$password+";Connection Timeout=60" 
      $SQLConnection.Open()
      break;
    }
  catch
   {
    Start-Sleep -s 5
   }
  }
   Write-output $SQLConnection
}

try
{
Clear-Host

$SQLConnectionSource = GiveMeConnectionSource
$SQLCommandExiste = New-Object System.Data.SqlClient.SqlCommand("Select Name from sys.databases Where database_id>=5 and name <>'distribution' Order by Name", $SQLConnectionSource) 
 $Reader = $SQLCommandExiste.ExecuteReader(); 
 while($Reader.Read())
   {
    $ComandoOut="c:\SqlPackage\Script\Export.bat " + $server + " " + $Reader.GetSqlString(0).ToString() + " " + $user + " " + $password + " " + $Folder+$Reader.GetSqlString(0).ToString() + ".bacpac" 
    Write-Host $ComandoOut
    Invoke-Expression -Command $ComandoOut
    }
   $Reader.Close();
$SQLConnectionSource.Close() 
}
catch
  {
    Write-Host -ForegroundColor DarkYellow "Error:"
    Write-Host -ForegroundColor Magenta $Error[0].Exception
  }
finally
{
   Write-Host -ForegroundColor Cyan "Process finished"
}


