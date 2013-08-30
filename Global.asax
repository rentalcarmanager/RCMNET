  <%@ Application Language="VB" %>
  <%@ Import Namespace="RCMAPIs" %>
  <script RunAt="server">
  
  Sub Application_BeginRequest(ByVal sender As [Object], ByVal e As EventArgs)
    '  Dim culture As String = String.Empty
    '  For Each key As String In Request.Form.Keys
    '    If key.Contains("ddlChangeLanguage") Then
    '      culture = Request.Form(key)
    '    End If
    '  Next
    '  System.Threading.Thread.CurrentThread.CurrentCulture = System.Globalization.CultureInfo.CreateSpecificCulture(culture)
    '  System.Threading.Thread.CurrentThread.CurrentUICulture = New System.Globalization.CultureInfo(culture)
    HttpContext.Current.Response.AddHeader("x-frame-options", "SAMEORIGIN")
  End Sub
  
  Sub Application_Start(ByVal sender As Object, ByVal e As EventArgs)
    ' Code that runs on application startup
    Dim sDBConnectStringRCMMain, sDBConnectStringRCMReadOnly, sDBConnectStringRCMWS As String
    sDBConnectStringRCMMain = ""
    sDBConnectStringRCMReadOnly = ""
    sDBConnectStringRCMWS = ""
    If Not RCMAPIs.EasyDBPoolcl.AreAllDBConnectionsSet() Then
    
      If (ConfigurationManager.ConnectionStrings.Count > 0) Then

        Dim connString As ConnectionStringSettings = ConfigurationManager.ConnectionStrings("RCMMain")
        If connString IsNot Nothing Then
          sDBConnectStringRCMMain = connString.ConnectionString
        End If
        connString = ConfigurationManager.ConnectionStrings("RCMReadOnly")
        If connString IsNot Nothing Then
          sDBConnectStringRCMReadOnly = connString.ConnectionString
        End If
        connString = ConfigurationManager.ConnectionStrings("RCMWS")
        If connString IsNot Nothing Then
          sDBConnectStringRCMWS = connString.ConnectionString
        End If
        'RCMAPIs.EasyDBPoolcl.SetAllDBConnections(sDBConnectStringRCMMain, sDBConnectStringRCMReadOnly)
        RCMAPIs.EasyDBPoolcl.SetAllDBConnections(sDBConnectStringRCMMain, sDBConnectStringRCMReadOnly, sDBConnectStringRCMWS)
      End If
    End If
  End Sub
  Sub Application_End(ByVal sender As Object, ByVal e As EventArgs)
    ' Code that runs on application shutdown
  End Sub
        
  Sub Application_Error(ByVal sender As Object, ByVal e As EventArgs)
    ' Code that runs when an unhandled error occurs
  End Sub

  Sub Session_Start(ByVal sender As Object, ByVal e As EventArgs)
    ' Code that runs when a new session is started
    Dim sDBConnectStringRCMMain, sDBConnectStringRCMReadOnly, sDBConnectStringRCMWS As String
    sDBConnectStringRCMMain = ""
    sDBConnectStringRCMReadOnly = ""
    sDBConnectStringRCMWS = ""
    If Not RCMAPIs.EasyDBPoolcl.AreAllDBConnectionsSet() Then
    
      If (ConfigurationManager.ConnectionStrings.Count > 0) Then

        Dim connString As ConnectionStringSettings = ConfigurationManager.ConnectionStrings("RCMMain")
        If connString IsNot Nothing Then
          sDBConnectStringRCMMain = connString.ConnectionString
        End If
        connString = ConfigurationManager.ConnectionStrings("RCMReadOnly")
        If connString IsNot Nothing Then
          sDBConnectStringRCMReadOnly = connString.ConnectionString
        End If
        connString = ConfigurationManager.ConnectionStrings("RCMWS")
        If connString IsNot Nothing Then
          sDBConnectStringRCMWS = connString.ConnectionString
        End If
        'RCMAPIs.EasyDBPoolcl.SetAllDBConnections(sDBConnectStringRCMMain, sDBConnectStringRCMReadOnly)
        RCMAPIs.EasyDBPoolcl.SetAllDBConnections(sDBConnectStringRCMMain, sDBConnectStringRCMReadOnly, sDBConnectStringRCMWS)
      End If
    End If
    RCMAPIs.Sessioncl.GetNewSessionID(Me.Session)
    RCMAPIs.Sessioncl.SetSessionCurrency(1, "AUD")
    RCMAPIs.Sessioncl.SetSessionCurrencyRate(1, 1)
    
  End Sub

  Sub Session_End(ByVal sender As Object, ByVal e As EventArgs)
    ' Code that runs when a session ends. 
    ' Note: The Session_End event is raised only when the sessionstate mode
    ' is set to InProc in the Web.config file. If session mode is set to StateServer 
    ' or SQLServer, the event is not raised.
  End Sub
  
  Public Function Replace2asp(ByVal filename As String) As String
    Dim str As String = Replace(System.Configuration.ConfigurationManager.AppSettings("2asp"), "%26", "&")
    If filename.Contains("&url=") Then
      Dim tempstr As String = filename.Substring(InStr(filename, "&url=") + 4)
      If tempstr.Contains(".aspx") Then
        str = Nothing
        filename = filename.Substring(InStr(filename, "&url=") + 4)
      End If
    End If
    str = str & filename
    Return str
  End Function
  
  Public Sub sessionActive()
    If (Session("LoginID") = "" Or IsNothing(Session("LoginID"))) And (Session("AccessLevel") = "" Or IsNothing(Session("AccessLevel"))) Then
      Session.Abandon()
      Response.Redirect(System.Configuration.ConfigurationManager.AppSettings("rcmHomelink"))
    End If
  End Sub
 Protected Sub ErrorMail_Mailing(ByVal sender As Object, ByVal e As Elmah.ErrorMailEventArgs)
    e.Mail.Subject = "Error # " & e.Error.Exception.Message
  End Sub
  </script>
