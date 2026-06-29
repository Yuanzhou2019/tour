import { App, Button, Form, Input, InputNumber, Modal, Popconfirm, Select, Space, Tag } from 'antd';
import { PlusOutlined } from '@ant-design/icons';
import type { ProColumns } from '@ant-design/pro-components';
import { ProTable } from '@ant-design/pro-components';
import { useEffect, useState } from 'react';
import http from '../../services/http';
import RichTextEditor from '../../components/RichTextEditor';
import type { DiscoverCard } from '../../types';

const categoryLabels: Record<string, string> = { curated: '精选', authentic: '地道', heads_up: '提醒' };
const categoryColors: Record<string, string> = { curated: 'purple', authentic: 'green', heads_up: 'orange' };

export default function DiscoverManagementPage() {
  const { message } = App.useApp();
  const [data, setData] = useState<DiscoverCard[]>([]);
  const [loading, setLoading] = useState(false);
  const [editModal, setEditModal] = useState<{ open: boolean; card?: DiscoverCard }>({ open: false });
  const [form] = Form.useForm();

  const fetchData = async () => {
    setLoading(true);
    try {
      const [curated, authentic, headsUp] = await Promise.all([
        http.get<{ data: DiscoverCard[] }>('/discover/curated'),
        http.get<{ data: DiscoverCard[] }>('/discover/authentic'),
        http.get<{ data: DiscoverCard[] }>('/discover/heads-up'),
      ]);
      setData([...curated.data.data, ...authentic.data.data, ...headsUp.data.data]);
    } catch { message.error('加载失败'); }
    finally { setLoading(false); }
  };

  useEffect(() => { fetchData(); }, []);

  const handleDelete = async (id: string) => {
    await http.delete(`/discover/${id}`);
    message.success('已删除');
    fetchData();
  };

  const onFinish = async (values: Record<string, unknown>) => {
    const c = editModal.card;
    try {
      if (c) await http.patch(`/discover/${c.id}`, values);
      else await http.post('/discover', values);
      message.success(c ? '修改成功' : '创建成功');
      setEditModal({ open: false });
      fetchData();
    } catch { message.error('保存失败'); }
  };

  const columns: ProColumns<DiscoverCard>[] = [
    { title: '英文标题', dataIndex: 'titleEn', key: 'titleEn', width: 250 },
    { title: '分类', dataIndex: 'category', key: 'category', width: 80,
      render: (_, r) => <Tag color={categoryColors[r.category]}>{categoryLabels[r.category]}</Tag> },
    { title: '排序', dataIndex: 'order', key: 'order', width: 60 },
    { title: '操作', key: 'action', width: 150,
      render: (_, r) => (
        <Space>
          <a onClick={() => { setEditModal({ open: true, card: r }); form.setFieldsValue(r); }}>编辑</a>
          <Popconfirm title="确认删除？" onConfirm={() => handleDelete(r.id)}>
            <a style={{ color: 'red' }}>删除</a>
          </Popconfirm>
        </Space>
      ),
    },
  ];

  return (
    <div style={{ padding: 24 }}>
      <ProTable<DiscoverCard> headerTitle="发现卡片" columns={columns}
        dataSource={data} loading={loading} rowKey="id" search={false} pagination={{ pageSize: 20 }}
        toolBarRender={() => [
          <Button key="add" type="primary" icon={<PlusOutlined />}
            onClick={() => { setEditModal({ open: true }); form.resetFields(); }}>新增卡片</Button>,
        ]}
      />
      <Modal title={editModal.card ? '编辑卡片' : '新增卡片'}
        open={editModal.open} onCancel={() => setEditModal({ open: false })}
        onOk={() => form.submit()} width={700} destroyOnClose>
        <Form form={form} layout="vertical" onFinish={onFinish}>
          <Form.Item name="category" label="分类" rules={[{ required: true }]}>
            <Select options={Object.entries(categoryLabels).map(([v, l]) => ({ label: l, value: v }))} />
          </Form.Item>
          <Form.Item name="titleZh" label="中文标题" rules={[{ required: true }]}>
            <Input />
          </Form.Item>
          <Form.Item name="titleEn" label="英文标题" rules={[{ required: true }]}>
            <Input />
          </Form.Item>
          <Form.Item name="summaryZh" label="中文摘要">
            <RichTextEditor placeholder="请输入中文摘要..." />
          </Form.Item>
          <Form.Item name="summaryEn" label="英文摘要">
            <RichTextEditor placeholder="请输入英文摘要..." />
          </Form.Item>
          <Form.Item name="imageUrl" label="图片链接">
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
