import { App, Button, Form, Input, InputNumber, Modal, Popconfirm, Select, Space } from 'antd';
import { PlusOutlined } from '@ant-design/icons';
import type { ProColumns } from '@ant-design/pro-components';
import { ProTable } from '@ant-design/pro-components';
import { useEffect, useState } from 'react';
import http from '../../services/http';
import type { Phrase } from '../../types';

const phraseCategories = [
  { label: '海关', value: 'customs' }, { label: '打车', value: 'taxi' },
  { label: '餐饮', value: 'dining' }, { label: '医疗', value: 'medical' },
  { label: '紧急', value: 'emergency' }, { label: '购物', value: 'shopping' },
];

export default function PhrasesManagementPage() {
  const { message } = App.useApp();
  const [data, setData] = useState<Phrase[]>([]);
  const [loading, setLoading] = useState(false);
  const [editModal, setEditModal] = useState<{ open: boolean; phrase?: Phrase }>({ open: false });
  const [form] = Form.useForm();

  const fetchData = async () => {
    setLoading(true);
    try {
      const res = await http.get<{ data: Phrase[] }>('/tools/phrases');
      setData(res.data.data);
    } catch { message.error('加载失败'); }
    finally { setLoading(false); }
  };

  useEffect(() => { fetchData(); }, []);

  const handleDelete = async (id: string) => {
    await http.delete(`/tools/phrases/${id}`);
    message.success('已删除');
    fetchData();
  };

  const onFinish = async (values: Record<string, unknown>) => {
    const p = editModal.phrase;
    try {
      if (p) await http.patch(`/tools/phrases/${p.id}`, values);
      else await http.post('/tools/phrases', values);
      message.success(p ? '修改成功' : '创建成功');
      setEditModal({ open: false });
      fetchData();
    } catch { message.error('保存失败'); }
  };

  const columns: ProColumns<Phrase>[] = [
    { title: '英文', dataIndex: 'en', key: 'en', width: 250 },
    { title: '中文', dataIndex: 'zh', key: 'zh', width: 150 },
    { title: '拼音', dataIndex: 'pinyin', key: 'pinyin', width: 180 },
    { title: '分类', dataIndex: 'category', key: 'category', width: 80 },
    { title: '排序', dataIndex: 'order', key: 'order', width: 60 },
    { title: '操作', key: 'action', width: 150,
      render: (_, r) => (
        <Space>
          <a onClick={() => { setEditModal({ open: true, phrase: r }); form.setFieldsValue(r); }}>编辑</a>
          <Popconfirm title="确认删除？" onConfirm={() => handleDelete(r.id)}>
            <a style={{ color: 'red' }}>删除</a>
          </Popconfirm>
        </Space>
      ),
    },
  ];

  return (
    <div style={{ padding: 24 }}>
      <ProTable<Phrase> headerTitle="常用语库" columns={columns}
        dataSource={data} loading={loading} rowKey="id" search={false} pagination={{ pageSize: 20 }}
        toolBarRender={() => [
          <Button key="add" type="primary" icon={<PlusOutlined />}
            onClick={() => { setEditModal({ open: true }); form.resetFields(); }}>新增常用语</Button>,
        ]}
      />
      <Modal title={editModal.phrase ? '编辑常用语' : '新增常用语'}
        open={editModal.open} onCancel={() => setEditModal({ open: false })}
        onOk={() => form.submit()} width={600} destroyOnClose>
        <Form form={form} layout="vertical" onFinish={onFinish}>
          <Form.Item name="category" label="分类" rules={[{ required: true }]}>
            <Select options={phraseCategories} />
          </Form.Item>
          <Form.Item name="en" label="英文" rules={[{ required: true }]}>
            <Input />
          </Form.Item>
          <Form.Item name="zh" label="中文" rules={[{ required: true }]}>
            <Input />
          </Form.Item>
          <Form.Item name="pinyin" label="拼音" rules={[{ required: true }]}>
            <Input />
          </Form.Item>
          <Form.Item name="order" label="排序">
            <InputNumber style={{ width: '100%' }} />
          </Form.Item>
        </Form>
      </Modal>
    </div>
  );
}
