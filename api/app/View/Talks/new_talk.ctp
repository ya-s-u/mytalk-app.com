<!DOCTYPE HTML lang="ja" lang="ja">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
</head>
<body>

<?php echo $this->Form->create('User',array('type'=>'file')); ?>

<?php echo $this->Form->file('upfile',array('name'=>'upfile')); ?>

<?php echo $this->Form->submit('アップロードする'); ?>
<?php echo $this->Form->end(); ?>

</body>
</html>