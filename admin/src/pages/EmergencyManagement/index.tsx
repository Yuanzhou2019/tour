import { App, Button, Form, Input, Modal, Popconfirm, Select, Space, Tag } from 'antd';
import { PlusOutlined } from '@ant-design/icons';
import type { ProColumns } from '@ant-design/pro-components';
import { ProTable } from '@ant-design/pro-components';
import { useEffect, useState } from 'react';
import http from '../../services/http';
import type { EmergencyContact } from '../../types';

const typeLabels: Record<string, string> = {
  police: '警察', medical: '医疗', fire: '消防', consulate: '领事馆', tourist_hotline: '旅游热线',
};
const typeColors: Record<string, string> = {
  police: 'blue', medical: 'red', fire: 'orange', consulate: 'purple', tourist_hotline: 'green',
};

export default function EmergencyManagementPage() {
  const { message } = App.useApp();
  const [data, setData] = useState<EmergencyContact[]>([]);
  const [loading, setLoading] = useState(false);
  const [editModal, setEditModal] = useState<{ open: boolean; contact?: EmergencyContact }>({ open: false });
  const [form] = Form.useForm();

  const fetchData = async () => {
    setLoading(true);
    try {
      const res = await http.get<{ data: EmergencyContact[] }>('/tools/emergency');
      setData(res.data.data);
    } catch { message.error('加载失败'); }
    finally { setLoading(false); }
  };

  useEffect(() => { fetchData(); }, []);

  const handleDelete = async (id: string) => {
    await http.delete(`/tools/emergency/${id}`);
    message.success('已删除');
    fetchData();
  };

  const onFinish = async (values: Record<string, unknown>) => {
    const c = editModal.contact;
    try {
      if (c) await http.patch(`/tools/emergency/${c.id}`, values);
      else await http.post('/tools/emergency', values);
      message.success(c ? '修改成功' : '创建成功');
      setEditModal({ open: false });
      fetchData();
    } catch { message.error('保存失败'); }
  };

  const columns: ProColumns<EmergencyContact>[] = [
    { title: '中文名称', dataIndex: 'nameZh', key: 'nameZh', width: 180 },
    { title: '英文名称', dataIndex: 'nameEn', key: 'nameEn', width: 200 },
    { title: '电话', dataIndex: 'phone', key: 'phone', width: 120 },
    { title: '国家', dataIndex: 'country', key: 'country', width: 80 },
    { title: '类型', dataIndex: 'type', key: 'type', width: 100,
      render: (_, r) => <Tag color={typeColors[r.type]}>{typeLabels[r.type]}</Tag> },
    { title: '操作', key: 'action', width: 150,
      render: (_, r) => (
        <Space>
          <a onClick={() => { setEditModal({ open: true, contact: r }); form.setFieldsValue(r); }}>编辑</a>
          <Popconfirm title="确认删除？" onConfirm={() => handleDelete(r.id)}>
            <a style={{ color: 'red' }}>删除</a>
          </Popconfirm>
        </Space>
      ),
    },
  ];

  return (
    <div style={{ padding: 24 }}>
      <ProTable<EmergencyContact> headerTitle="紧急联系方式" columns={columns}
        dataSource={data} loading={loading} rowKey="id" search={false} pagination={{ pageSize: 20 }}
        toolBarRender={() => [
          <Button key="add" type="primary" icon={<PlusOutlined />}
            onClick={() => { setEditModal({ open: true }); form.resetFields(); }}>新增联系方式</Button>,
        ]}
      />
      <Modal title={editModal.contact ? '编辑联系方式' : '新增联系方式'}
        open={editModal.open} onCancel={() => setEditModal({ open: false })}
        onOk={() => form.submit()} width={600} destroyOnClose>
        <Form form={form} layout="vertical" onFinish={onFinish}>
          <Form.Item name="country" label="国家（* 表示通用）" rules={[{ required: true }]}>
            <Input placeholder="* 或国家代码" />
          </Form.Item>
          <Form.Item name="type" label="类型" rules={[{ required: true }]}>
            <Select options={Object.entries(typeLabels).map(([v, l]) => ({ label: l, value: v }))} />
          </Form.Item>
          <Form.Item name="nameZh" label="中文名称" rules={[{ required: true }]}>
            <Input />
          </Form.Item>
          <Form.Item name="nameEn" label="英文名称" rules={[{ required: true }]}>
            <Input />
          </Form.Item>
          <Form.Item name="phone" label="电话" rules={[{ required: true }]}>
            <Input />
          </Form.Item>
          <Form.Item name="addressZh" label="中文地址">
            <Input />
          </Form.Item>
          <Form.Item name="addressEn" label="英文地址">
            <Input />
          </Form.Item>
        </Form>
      </Modal>
    </div>
  );
}
