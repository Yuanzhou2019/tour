import { App, Button, Form, Input, InputNumber, Modal, Popconfirm, Select, Space } from 'antd';
import { PlusOutlined } from '@ant-design/icons';
import type { ProColumns } from '@ant-design/pro-components';
import { ProTable } from '@ant-design/pro-components';
import { useEffect, useState } from 'react';
import http from '../../services/http';
import type { Rank } from '../../types';

const rankCategories = [
  { label: '餐饮', value: 'dining' }, { label: '购物', value: 'shopping' },
  { label: '景点', value: 'attraction' }, { label: '亲子', value: 'family' },
  { label: '情侣', value: 'couple' }, { label: '避坑', value: 'warning' },
];

export default function RankManagementPage() {
  const { message } = App.useApp();
  const [data, setData] = useState<Rank[]>([]);
  const [loading, setLoading] = useState(false);
  const [editModal, setEditModal] = useState<{ open: boolean; rank?: Rank }>({ open: false });
  const [form] = Form.useForm();

  const fetchData = async () => {
    setLoading(true);
    try {
      const all: Rank[] = [];
      for (const cat of rankCategories) {
        try {
          const res = await http.get<{ data: Rank[] }>(`/ranks/${cat.value}`);
          all.push(...res.data.data);
        } catch { /* 该分类可能没有数据 */ }
      }
      setData(all);
    } catch { message.error('加载失败'); }
    finally { setLoading(false); }
  };

  useEffect(() => { fetchData(); }, []);

  const handleDelete = async (id: string) => {
    await http.delete(`/ranks/${id}`);
    message.success('已删除');
    fetchData();
  };

  const onFinish = async (values: Record<string, unknown>) => {
    const r = editModal.rank;
    try {
      if (r) await http.patch(`/ranks/${r.id}`, values);
      else await http.post('/ranks', values);
      message.success(r ? '修改成功' : '创建成功');
      setEditModal({ open: false });
      fetchData();
    } catch { message.error('保存失败'); }
  };

  const columns: ProColumns<Rank>[] = [
    { title: '标题', dataIndex: 'titleZh', key: 'titleZh', width: 250 },
    { title: '分类', dataIndex: 'category', key: 'category', width: 100 },
    { title: '条目数', dataIndex: 'items', key: 'items', width: 80, render: (_, r) => r.items?.length ?? 0 },
    { title: '排序', dataIndex: 'order', key: 'order', width: 60 },
    { title: '操作', key: 'action', width: 150,
      render: (_, r) => (
        <Space>
          <a onClick={() => { setEditModal({ open: true, rank: r }); form.setFieldsValue(r); }}>编辑</a>
          <Popconfirm title="确认删除？" onConfirm={() => handleDelete(r.id)}>
            <a style={{ color: 'red' }}>删除</a>
          </Popconfirm>
        </Space>
      ),
    },
  ];

  return (
    <div style={{ padding: 24 }}>
      <ProTable<Rank> headerTitle="榜单管理" columns={columns}
        dataSource={data} loading={loading} rowKey="id" search={false} pagination={{ pageSize: 20 }}
        toolBarRender={() => [
          <Button key="add" type="primary" icon={<PlusOutlined />}
            onClick={() => { setEditModal({ open: true }); form.resetFields(); }}>新增榜单</Button>,
        ]}
      />
      <Modal title={editModal.rank ? '编辑榜单' : '新增榜单'}
        open={editModal.open} onCancel={() => setEditModal({ open: false })}
        onOk={() => form.submit()} width={700} destroyOnClose>
        <Form form={form} layout="vertical" onFinish={onFinish}>
          <Form.Item name="category" label="分类" rules={[{ required: true }]}>
            <Select options={rankCategories} />
          </Form.Item>
          <Form.Item name="titleZh" label="中文标题" rules={[{ required: true }]}>
            <Input />
          </Form.Item>
          <Form.Item name="titleEn" label="英文标题" rules={[{ required: true }]}>
            <Input />
          </Form.Item>
          <Form.Item name="order" label="排序">
            <InputNumber style={{ width: '100%' }} />
          </Form.Item>
          <Form.Item name="items" label="榜单条目 (JSON)">
            <Input.TextArea rows={8}
              placeholder='[{"poiId":"uuid","reasonZh":"理由","reasonEn":"Reason","order":1}]'
            />
          </Form.Item>
        </Form>
      </Modal>
    </div>
  );
}
