use Test::More tests => 50;
BEGIN { use_ok('WWW::BookBot::Test'); use_ok(test_init('WWW::BookBot::Chinese')); };
test_begin();

#------ en_code and de_code
$str="���Դ���";
new_bot(LANGUAGE_ENCODE=>'', LANGUAGE_DECODE=>'');
test_encoding($str, $str, "without conversion");
new_bot();
test_encoding($str, $str, "with conversion");

#------ parse_patterns
test_parse_patterns('$3$4', '\$3\$4', 'auto \\');
test_parse_patterns("\n1\n2\n3\n4\n", '1|2|3|4', '\\n -> |');
test_parse_patterns('Ab', '[aA][bB]', 'case insensitive');
test_parse_patterns('\b[a-ZbE]', '\b[a-ZbE]', 'special forms of RE');
test_parse_patterns("(case)\n����DDD\n˳��EEE", '����DDD|˳��EEE', 'preserve case sensitive');

#------ utilities: msg_format, files, log, result, DB
my $msg_para={TestInfo=>"����",TestNum=>7};
my $msg_result="����: ���� 7";
test_msg_format($msg_para, $msg_result);
test_file("��", "��");
test_log("��", "��", "����\$����", $msg_para, $msg_result);
test_result("��", "��");
test_DB();

#------ agent, url, fetch
test_agent();
test_url();
test_fetch();

#------ parse functions
#$bot->{REMOVE_LEADING_SPACES}=1;
#test_parser('remove_leadingspace',
#	"\n   ����\n  ����\n  ����\n  ����\n  �ġ�\n",
#	"\n ����\n����\n����\n����\n�ġ�\n",
#);
#$bot->{REMOVE_INNER_SPACES}=1;
#test_parser('remove_innerspace',
#	"���� �� �� �� �� Կ �� �� �� �� �� �� �棭���� �� �� �� ���� �� Կ �� �� �� ��",
#	"���� ��������Կ���û��Լ����棭���� ���������� ��Կ��������",
#);
new_bot();
test_parser('normalize_space', "\001\002��", '    ');
test_parser('remove_html',
	"<a href='5'> ����</a>\n<script src='my.js'>do();\n</script>��ȷ<!--<br>��ʾ\n-->",
	" ����\n��ȷ",
);
test_parser('decode_entity', '&nbsp;&#79&#107;', ' Ok');
test_parser('normalize_paragraph_1',
	"\n  ����\n�� �� ��\n\n----\n ��ȷ  \n  ",
	" ����\n ---\n ��ȷ",
);
test_parser('parse_title',
	"  ���⡶��ʾ ��\n ������  ",
	"���⡶��ʾ �� ������",
	"without enclose",
);
test_parser('parse_title',
	"  �����Ա��⡷��  ",
	"���Ա���",
	"with enclose",
);
test_parser('normalize_paragraph',
	"\n   ����<br>\n��ȷ  \n",
	"��������\n������ȷ",
);

#------ parse utilities
test_catalog_get_book(
	"����Ŀ¼",
	"��ʼ <a href='my.txt' target=_blank\n>����</A> ����",
	"http://www.sina.com.cn/my.txt",
	"����"
);
test_book_chapters(
	"����Ŀ¼",
	"��ʼ <a href='my.txt' target=_blank\n>����</A> ����",
	"http://www.sina.com.cn/my.txt",
	"����"
);
test_writebin("����\n����");
test_parse_bintext("�����ı�");

#------ The End
#dump_var('Patterns');
#test_pattern('remove_line_by_end', '�л���');
test_end;