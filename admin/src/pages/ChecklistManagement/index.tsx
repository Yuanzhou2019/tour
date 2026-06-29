import { App, Button, Form, Input, Modal, Popconfirm, Select, Space } from 'antd';
import { PlusOutlined } from '@ant-design/icons';
import type { ProColumns } from '@ant-design/pro-components';
import { ProTable } from '@ant-design/pro-components';
import { useEffect, useState } from 'react';
import http from '../../services/http';
import type { Checklist, ChecklistItem } from '../../types';

const countryOptions = [
  { label: '美国', value: 'US' }, { label: '英国', value: 'GB' }, { label: '日本', value: 'JP' },
  { label: '韩国', value: 'KR' }, { label: '德国', value: 'DE' },
];

const cities = [
  { label: '上海', value: 'SH' }, { label: '北京', value: 'BJ' }, { label: '广州', value: 'GZ' },
];

const reasonLabels: Record<string, string> = { tourism: '旅游', business: '商务' };

export default function ChecklistManagementPage() {
  const { message } = App.useApp();
  const [data, setData] = useState<Checklist[]>([]);
  const [loading, setLoading] = useState(false);
  const [editModal, setEditModal] = useState<{ open: boolean; checklist?: Checklist }>({ open: false });
  const [form] = Form.useForm();

  const fetchData = async () => {
    setLoading(true);
    try {
      const res = await http.get<{ data: Checklist[] }>('/checklists');
      setData(res.data.data);
    } catch { message.error('加载失败'); }
    finally { setLoading(false); }
  };

  useEffect(() => { fetchData(); }, []);

  const handleDelete = async (id: string) => {
    await http.delete(`/checklists/${id}`);
    message.success('已删除');
    fetchData();
  };

  const onFinish = async (values: Record<string, unknown>) => {
    const c = editModal.checklist;
    try {
      if (c) await http.patch(`/checklists/${c.id}`, values);
      else await http.post('/checklists', values);
      message.success(c ? '修改成功' : '创建成功');
      setEditModal({ open: false });
      fetchData();
    } catch { message.error('保存失败'); }
  };

  const columns: ProColumns<Checklist>[] = [
    { title: '英文标题', dataIndex: 'titleEn', key: 'titleEn', width: 250 },
    { title: '国家', dataIndex: 'country', key: 'country', width: 70 },
    { title: '城市', dataIndex: 'city', key: 'city', width: 60 },
    { title: '事由', dataIndex: 'reason', key: 'reason', width: 80, render: (_, r) => reasonLabels[r.reason] ?? r.reason },
    { title: '条目数', dataIndex: 'items', key: 'items', width: 80, render: (_, r) => r.items?.length ?? 0 },
    { title: '操作', key: 'action', width: 150,
      render: (_, r) => (
        <Space>
          <a onClick={() => { setEditModal({ open: true, checklist: r }); form.setFieldsValue(r); }}>编辑</a>
          <Popconfirm title="确认删除？" onConfirm={() => handleDelete(r.id)}>
            <a style={{ color: 'red' }}>删除</a>
          </Popconfirm>
        </Space>
      ),
    },
  ];

  return (
    <div style={{ padding: 24 }}>
      <ProTable<Checklist> headerTitle="清单管理" columns={columns}
        dataSource={data} loading={loading} rowKey="id" search={false} pagination={{ pageSize: 20 }}
        toolBarRender={() => [
          <Button key="add" type="primary" icon={<PlusOutlined />}
            onClick={() => { setEditModal({ open: true }); form.resetFields(); }}>新增清单</Button>,
        ]}
      />
      <Modal title={editModal.checklist ? '编辑清单' : '新增清单'}
        open={editModal.open} onCancel={() => setEditModal({ open: false })}
        onOk={() => form.submit()} width={700} destroyOnClose>
        <Form form={form} layout="vertical" onFinish={onFinish}>
          <Form.Item name="country" label="国家" rules={[{ required: true }]}>
            <Select options={countryOptions} />
          </Form.Item>
          <Form.Item name="reason" label="入境事由" rules={[{ required: true }]}>
            <Select options={[
              { label: '旅游', value: 'tourism' }, { label: '商务', value: 'business' },
            ]} />
          </Form.Item>
          <Form.Item name="city" label="城市" rules={[{ required: true }]}>
            <Select options={cities} />
          </Form.Item>
          <Form.Item name="titleZh" label="中文标题" rules={[{ required: true }]}>
            <Input />
          </Form.Item>
          <Form.Item name="titleEn" label="英文标题" rules={[{ required: true }]}>
            <Input />
          </Form.Item>
          <Form.Item name="items" label="清单条目 (JSON)">
            <Input.TextArea rows={8}
              placeholder='[{"id":"1","titleZh":"护照","titleEn":"Passport","order":1}]'
            />
          </Form.Item>
        </Form>
      </Modal>
    </div>
  );
}
