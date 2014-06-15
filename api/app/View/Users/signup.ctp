<!DOCTYPE HTML lang="ja" lang="ja">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>

<?php echo $this->Form->create('User'); ?>

<?php echo $this->Form->input('address'); ?>
<?php echo $this->Form->input('password'); ?>

<?php echo $this->Form->submit('ログインする'); ?>
<?php echo $this->Form->end(); ?>

</body>
</html>