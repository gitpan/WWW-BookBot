package WWW::BookBot::Chinese;

use 5.008;
use strict;
use warnings;
no warnings qw(uninitialized);
use base qw(WWW::BookBot);
use vars qw($VERSION);
$VERSION = '0.12';

#-------------------------------------------------------------
# Default settings
#	$class->default_settings						=> \%settings
#-------------------------------------------------------------
sub default_settings {
	my $self = shift->SUPER::default_settings;
	$self->{get_language}='zh-cn';
	$self->{language_decode}='gbk';
	$self->{language_encode}='gbk';
	$self;
}

#-------------------------------------------------------------
# Redefined functions
#	$bot->decode_entity($content_dein_deout)			=> N/A
#	$bot->trandict_init								=> $bot->{translate_dict}
#	$bot->msg_init									=> $bot->{messages}
#-------------------------------------------------------------
sub decode_entity {
	#chinese novels sometimes add \x{FF1B} after unkown unicode string
	$_[1]=~s/(?:&\#(\d{1,5});?\x{FF1B}?)/chr($1)/esg;
	$_[1]=~s/(?:&\#[xX]([0-9a-fA-F]{1,5});?\x{FF1B}?)/chr(hex($1))/esg;
	$_[1]=~s/(&([0-9a-zA-Z]{1,9});?)/$WWW::BookBot::entity2char{$2} or $1/esg;
	#normalize middle dot
	$_[1]=~s/\x{2022}/\x{00B7}/sg;
}
sub trandict_init {
	shift->{translate_dict} = {
		'log'		=> "��־",
		'result'	=> "���",
		'DB'		=> "����",
		'debug'		=> "����",
	}
}
sub msg_init {
	my $skip_info="\n".'$pargs->{levelspace}  url=$pargs->{url}'."\n";
	shift->{messages} = {
		TestMsg			=> '����: $pargs->{TestInfo} $pargs->{TestNum}',
		BookStart		=> '$pargs->{levelspace} [$pargs->{bpos_limit}/$pargs->{book_num}] $pargs->{title_limit} ',
		BookBinaryOK	=> '$pargs->{data_len_KB} $pargs->{write_file}'."\n",
		BookChapterErr	=> ' - �޷�����'.$skip_info,
		BookChapterMany	=> '[$pargs->{chapter_num_limit}��]',
		BookChapterOne	=> '[���½�]',
		BookChapterOK	=> '$pargs->{data_len_KB}'."\n",
		BookTOCFinish	=> '$pargs->{TOC_len_KB}'."\n",
		CatalogInfo		=> 'ȡ��Ŀ: ',
		CatalogResultErr=> ' 0����'."\n",
		CatalogResultOK	=> ' $pargs->{book_num}����'."\n",
		CatalogURL		=> '$pargs->{url}',
		CatalogURLEmpty	=> '[ʧ��] ������URLΪ��'."\n",
		DBBookErr		=> "\t".' \$bot->go_book({$pargs->{allargs}});'."\t#����\n",
		DBBookOK		=> "\t".'#\$bot->go_book({$pargs->{allargs}});'."\n",
		DBCatalogErr	=> ' \$bot->go_catalog({$pargs->{allargs}});'."\t#����\n",
		DBCatalogOK		=> '#\$bot->go_catalog({$pargs->{allargs}});'."\n",
		DBHead			=> <<'DATA',
#!$pargs->{perlcmd}
##======================================
## �Զ����ɵ������ļ�������$pargs->{classname}
##    ����ʱ��: $pargs->{createtime}
##======================================

use $pargs->{classname};
my \$bot = new $pargs->{classname};

DATA
		FailClearDB		=> '�޷���������ļ�$pargs->{filename}: $pargs->{errmsg}',
		FailClose	 	=> '�޷��ر�$self->{translate_dict}->{$pargs->{filetype}}�ļ�$pargs->{filename}: $pargs->{errmsg}',
		FailMkDir		=> '��Ŀ¼$pargs->{dir}ʧ��: $pargs->{errmsg}',
		FailOpen	 	=> '�޷���$self->{translate_dict}->{$pargs->{filetype}}�ļ�$pargs->{filename}: $pargs->{errmsg}',
		FailWrite	 	=> '�޷�д��$self->{translate_dict}->{$pargs->{filetype}}�ļ�$pargs->{filename}: $pargs->{errmsg}',
		GetFail404		=> <<'DATA',
[$pargs->{code},ʧ��] �Ҳ����ļ�
        $pargs->{url_real}
DATA
		GetFail404Detail=> <<'DATA',
[$pargs->{code},ʧ��] �Ҳ����ļ�
>>>>����
$pargs->{req_content}<<<<��Ӧ
$pargs->{status_line}

DATA
		GetFailRetries	=> <<'DATA',
[$pargs->{code},ʧ��] ����̫�࣬����
        $pargs->{url_real}
DATA
		GetFailRetriesDetail	=> <<'DATA',
[$pargs->{code},ʧ��] ����̫�࣬����
>>>>����
$pargs->{req_content}<<<<��Ӧ
$pargs->{status_line}
$pargs->{res_content}

DATA
		GetURLSuccess	=> '$pargs->{len_KB} ',
		GetURLRetry		=> '[$pargs->{code},����] ',
		GetWait			=> '�ȴ�..',
		SkipMaxLevel	=> '[����]����>$self->{book_max_levels}'.$skip_info,
		SkipMedia		=> '[����]ý���ļ�'.$skip_info,
		SkipTitleEmpty	=> '[����]����Ϊ��'.$skip_info,
		SkipUrlEmpty	=> '[����]��ַΪ��'."\n",
		SkipVisited		=> '[����]�ѷ��ʹ�'."\n",
		SkipZip			=> '[����]ѹ���ļ�'.$skip_info,
	};
}

#-------------------------------------------------------------
# patterns
#-------------------------------------------------------------
sub getpattern_space2_data {
	<<'DATA';
[�����@]
DATA
}
sub getpattern_line_head_data {
	'����';
}
sub getpattern_parentheses_data {
	shift->SUPER::getpattern_parentheses_data().<<'DATA';
�� ��
�� ��
�� ��
�� ��
�� ��
�� ��
�� ��
�� ��
�� ��
�� ��
�� ��
�� ��
�� ��
�� ��
�� ��
�� ��
�� ��
�� ��
�� ��
�� ��
�� ��
�� ��
�� ��
�� ��
�� ��
�� ��
�� ��
�� ��
�A �@
�F �F
�� ��
�v �w
�x �y
�z �{
�� ��
DATA
}
sub getpattern_mark_dash_data {
	<<'DATA';
[#-&\*\+\-=@_~�������������¡ˡѡԡ֡סޡ����죣���������������ߣ��C�D�E�O�W�\�`��-�ᩖ������-���h-�n�~������������]
DATA
}
sub getpattern_mark_wordsplit_data {
	<<'DATA';
[\.\,\?\!\:\;�á������������������U�o�p�q�r�s�t�u]
DATA
}
sub getpattern_word_finish_data {
	<<'DATA';
(?:ȫ[����]|)[����]
DATA
}
sub getpattern_remove_line_by_end_data {
	<<'DATA';
(case)
[������Ѷ]
[��������������ɨУ�ϱ��������Ŀ�����С��ת][ѧ������]?(?:[�����Ű���Ʒ������У�����������ݿ��·��Է��������]|����|��Զ��|�һ�Դ|-K12)(?:���|)
��(?:������Ȩ|����վ̨��Ϣ)[�����q\.���u]?
����
[Oo�ϣ�][Cc�ã�][Rr�ң�]
�ɱ�����
�ෲ����ͼ���
�������
ʧ����ǳ�
�����ŵ�
����¥
һ��С����
��¶�ɷ�
�｣����ʿ
����ʱ��
ð��������
��Ϣ����
cnread[\.�������q]net
ezla[\.�������q]com?[\.�������q]tw
thebook[\.�������q]yeah[\.�������q]net
y(?:esho[\.�������q]com/wenxue|uzispy[\.�������q]yeah[\.�������q]net)
www[\.�������q](?:v-war|oldrain)[\.�������q](?:net|com)
DATA
}
sub getpattern_remove_line_by_end_special_data {
	<<'DATA';
������Ѷ
DATA
}

1;
__END__

=head1 NAME

WWW::BookBot::Chinese - Virtual class of bots to process chinese e-texts.

=head1 SYNOPSIS

  use WWW::BookBot::Chinese::Novel::DragonSky;
  my $bot=WWW::BookBot::Chinese::Novel::DragonSky->new({work_dir=>'/output'});
  $bot->go_catalog({});

  use WWW::BookBot::Chinese::Novel::ShuKu;
  my $bot=WWW::BookBot::Chinese::Novel::ShuKu->new({});
  $bot->go_catalog({desc=>'NewNovel', cat1=>0, cat2=>1, pageno=>0});

=head1 ABSTRACT

Virtual class of bots to process chinese e-texts.

=head1 DESCRIPTION

Virtual class of bots to process chinese e-texts.

to be added.

=head2 EXPORT

None by default.

=head1 BUGS, REQUESTS, COMMENTS

Please report any requests, suggestions or bugs via
http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-BookBot

=head1 AUTHOR

Qing-Jie Zhou E<lt>qjzhou@hotmail.comE<gt>

=head1 SEE ALSO

L<WWW::BookBot>

=cut
