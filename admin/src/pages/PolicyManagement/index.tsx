import { App, Button, Form, Input, Modal, Popconfirm, Select, Space, Tag } from 'antd';
import { PlusOutlined } from '@ant-design/icons';
import type { ProColumns } from '@ant-design/pro-components';
import { ProTable } from '@ant-design/pro-components';
import { useEffect, useState } from 'react';
import http from '../../services/http';
import RichTextEditor from '../../components/RichTextEditor';
import type { Policy } from '../../types';

const countryOptions = [
  { label: '美国', value: 'US' }, { label: '英国', value: 'GB' }, { label: '日本', value: 'JP' },
  { label: '韩国', value: 'KR' }, { label: '德国', value: 'DE' }, { label: '法国', value: 'FR' },
  { label: '澳大利亚', value: 'AU' }, { label: '加拿大', value: 'CA' }, { label: '新加坡', value: 'SG' },
  { label: '马来西亚', value: 'MY' },
];

const categoryLabels: Record<string, string> = {
  visa_free: '免签', visa_required: '需签证', transit: '过境',
  customs: '海关', consular: '领事', residence: '居留',
};
const categoryColors: Record<string, string> = {
  visa_free: 'green', visa_required: 'red', transit: 'blue',
  customs: 'orange', consular: 'purple', residence: 'cyan',
};

export default function PolicyManagementPage() {
  const { message } = App.useApp();
  const [data, setData] = useState<Policy[]>([]);
  const [loading, setLoading] = useState(false);
  const [editModal, setEditModal] = useState<{ open: boolean; policy?: Policy }>({ open: false });
  const [form] = Form.useForm();

  const fetchData = async () => {
    setLoading(true);
    try {
      const res = await http.get<{ data: Policy[] }>('/policies');
      setData(res.data.data);
    } catch { message.error('加载失败'); }
    finally { setLoading(false); }
  };

  useEffect(() => { fetchData(); }, []);

  const handleDelete = async (id: string) => {
    await http.delete(`/policies/${id}`);
    message.success('已删除');
    fetchData();
  };

  const onFinish = async (values: Record<string, unknown>) => {
    const p = editModal.policy;
    try {
      if (p) await http.patch(`/policies/${p.id}`, values);
      else await http.post('/policies', values);
      message.success(p ? '修改成功' : '创建成功');
      setEditModal({ open: false });
      fetchData();
    } catch { message.error('保存失败'); }
  };

  const columns: ProColumns<Policy>[] = [
    { title: '中文标题', dataIndex: 'titleZh', key: 'titleZh', width: 200 },
    { title: '国家', dataIndex: 'country', key: 'country', width: 60 },
    { title: '入境事由', dataIndex: 'reason', key: 'reason', width: 100 },
    { title: '分类', dataIndex: 'category', key: 'category', width: 100,
      render: (_, r) => <Tag color={categoryColors[r.category]}>{categoryLabels[r.category]}</Tag> },
    { title: '操作', key: 'action', width: 150,
      render: (_, r) => (
        <Space>
          <a onClick={() => { setEditModal({ open: true, policy: r }); form.setFieldsValue(r); }}>编辑</a>
          <Popconfirm title="确认删除？" onConfirm={() => handleDelete(r.id)}>
            <a style={{ color: 'red' }}>删除</a>
          </Popconfirm>
        </Space>
      ),
    },
  ];

  return (
    <div style={{ padding: 24 }}>
      <ProTable<Policy> headerTitle="政策管理" columns={columns} dataSource={data}
        loading={loading} rowKey="id" search={false} pagination={{ pageSize: 20 }}
        toolBarRender={() => [
          <Button key="add" type="primary" icon={<PlusOutlined />}
            onClick={() => { setEditModal({ open: true }); form.resetFields(); }}>新增政策</Button>,
        ]}
      />
      <Modal title={editModal.policy ? '编辑政策' : '新增政策'}
        open={editModal.open} onCancel={() => setEditModal({ open: false })}
        onOk={() => form.submit()} width={700} destroyOnClose>
        <Form form={form} layout="vertical" onFinish={onFinish}>
          <Form.Item name="country" label="国家" rules={[{ required: true }]}>
            <Select options={countryOptions} />
          </Form.Item>
          <Form.Item name="reason" label="入境事由" rules={[{ required: true }]}>
            <Select options={[
              { label: '旅游', value: 'tourism' }, { label: '商务', value: 'business' },
              { label: '探亲', value: 'family_visit' }, { label: '留学', value: 'education' },
            ]} />
          </Form.Item>
          <Form.Item name="category" label="分类" rules={[{ required: true }]}>
            <Select options={Object.entries(categoryLabels).map(([v, l]) => ({ label: l, value: v }))} />
          </Form.Item>
          <Form.Item name="titleZh" label="中文标题" rules={[{ required: true }]}>
            <Input />
          </Form.Item>
          <Form.Item name="titleEn" label="英文标题" rules={[{ required: true }]}>
            <Input />
          </Form.Item>
          <Form.Item name="contentZh" label="中文内容">
            <RichTextEditor placeholder="请输入政策中文内容..." />
          </Form.Item>
          <Form.Item name="contentEn" label="英文内容">
            <RichTextEditor placeholder="请输入政策英文内容..." />
          </Form.Item>
          <Form.Item name="sourceName" label="来源">
            <Input />
          </Form.Item>
        </Form>
      </Modal>
    </div>
  );
}
