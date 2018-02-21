<!DOCTYPE html>
<html lang="zh-cn">
<head>
    <meta charset="utf-8">
    <link rel="shortcut icon" href="/favicon.ico">
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1" />
    <meta name="renderer" content="webkit" />
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="author" content="SmartWiki" />
    <title>User Login - Powered by MinDoc</title>

    <!-- Bootstrap -->
    <link href="{{cdncss "/static/bootstrap/css/bootstrap.min.css"}}" rel="stylesheet">
    <link href="{{cdncss "/static/font-awesome/css/font-awesome.min.css"}}" rel="stylesheet">
    <link href="/static/css/main.css" rel="stylesheet">
    <!-- HTML5 shim and Respond.js for IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>
    <script src="/static/html5shiv/3.7.3/html5shiv.min.js"></script>
    <script src="/static/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
    <!-- jQuery (necessary for Bootstrap's JavaScript plugins) -->
    <script src="{{cdnjs "/static/jquery/1.12.4/jquery.min.js"}}"></script>
</head>
<body class="manual-container">
<header class="navbar navbar-static-top smart-nav navbar-fixed-top manual-header" role="banner">
    <div class="container">
        <div class="navbar-header col-sm-12 col-md-6 col-lg-5">
            <a href="/" class="navbar-brand">{{.SITE_NAME}}</a>
        </div>
    </div>
</header>
<div class="container manual-body">
    <div class="row login">
        <div class="login-body">
            <form role="form" method="post" id="registerForm">
                <h3 class="text-center">User Register</h3>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">
                            <i class="fa fa-user"></i>
                        </div>
                        <input type="text" class="form-control" placeholder="Username" name="account" id="account" autocomplete="off">
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">
                            <i class="fa fa-lock"></i>
                        </div>
                        <input type="password" class="form-control" placeholder="Password" name="password1" id="password1" autocomplete="off">
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon">
                            <i class="fa fa-lock"></i>
                        </div>
                        <input type="password" class="form-control" placeholder="Confirm Password" name="password2" id="password2" autocomplete="off">
                    </div>
                </div>
                <div class="form-group">
                    <div class="input-group">
                        <div class="input-group-addon" style="padding: 6px 9px;"><i class="fa fa-envelope"></i></div>
                        <input type="email" class="form-control" placeholder="E-mail" name="email" id="email" autocomplete="off">
                    </div>
                </div>

                <div class="form-group">
                    <div class="input-group" style="float: left;width: 195px;">
                        <div class="input-group-addon">
                            <i class="fa fa-check-square"></i>
                        </div>
                        <input type="text" name="code" id="code" class="form-control" style="width: 150px" maxlength="5" placeholder="Verification Code" autocomplete="off">&nbsp;
                    </div>
                    <img id="captcha-img" style="width: 140px;height: 40px;display: inline-block;float: right" src="{{urlfor "AccountController.Captcha"}}" onclick="this.src='{{urlfor "AccountController.Captcha"}}?key=login&t='+(new Date()).getTime();" title="Click to change">
                    <div class="clearfix"></div>
                </div>

                <div class="form-group">
                    <button type="submit" id="btnRegister" class="btn btn-success" style="width: 100%"  data-loading-text="Registering..." autocomplete="off">Register</button>
                </div>
                {{if ne .ENABLED_REGISTER "false"}}
                <div class="form-group">
                    Have an account？<a href="{{urlfor "AccountController.Login" }}" title="Login">Login</a>
                </div>
                {{end}}
            </form>
        </div>
    </div>
    <div class="clearfix"></div>
</div>
{{template "widgets/footer.tpl" .}}
<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="{{cdnjs "/static/bootstrap/js/bootstrap.min.js"}}" type="text/javascript"></script>
<script src="{{cdnjs "/static/layer/layer.js"}}" type="text/javascript"></script>
<script src="{{cdnjs "/static/js/jquery.form.js"}}" type="text/javascript"></script>
<script type="text/javascript">
    $(function () {
        $("#account,#password,#confirm_password,#code").on('focus',function () {
            $(this).tooltip('destroy').parents('.form-group').removeClass('has-error');
        });

        $(document).keyup(function (e) {
            var event = document.all ? window.event : e;
            if(event.keyCode === 13){
                $("#btnRegister").trigger("click");
            }
        });
        $("#registerForm").ajaxForm({
            beforeSubmit : function () {
                var account = $.trim($("#account").val());
                var password = $.trim($("#password1").val());
                var confirmPassword = $.trim($("#password2").val());
                var code = $.trim($("#code").val());
                var email = $.trim($("#email").val());

                if(account === ""){
                    $("#account").focus().tooltip({placement:"auto",title : "Username can not be empty",trigger : 'manual'})
                        .tooltip('show')
                        .parents('.form-group').addClass('has-error');
                    return false;

                }else if(password === ""){
                    $("#password").focus().tooltip({title : 'Password can not be empty',trigger : 'manual'})
                        .tooltip('show')
                        .parents('.form-group').addClass('has-error');
                    return false;
                }else if(confirmPassword !== password){
                    $("#confirm_password").focus().tooltip({title : 'Passwords are not equal',trigger : 'manual'})
                        .tooltip('show')
                        .parents('.form-group').addClass('has-error');
                    return false;
                }else if(email === ""){
                    $("#email").focus().tooltip({title : 'Email can not be empty',trigger : 'manual'})
                        .tooltip('show')
                        .parents('.form-group').addClass('has-error');
                    return false;
                }else if(code !== undefined && code === ""){
                    $("#code").focus().tooltip({title : 'Verification code can not be empty',trigger : 'manual'})
                        .tooltip('show')
                        .parents('.form-group').addClass('has-error');
                    return false;
                }else {

                    $("button[type='submit']").button('loading');
                }
            },
            success : function (res) {
                $("button[type='submit']").button('reset');
                if(res.errcode === 0){
                    window.location = "{{urlfor "AccountController.Login"}}";
                }else{
                    $("#captcha-img").click();
                    $("#code").val('');
                    layer.msg(res.message);
                }
            }
        });
    });
</script>
</body>
</html>