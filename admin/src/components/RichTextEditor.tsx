import { useRef } from 'react';
import ReactQuill from 'react-quill-new';
import 'react-quill-new/dist/quill.snow.css';
import http from '../services/http';

interface Props {
  value?: string;
  onChange?: (value: string) => void;
  placeholder?: string;
  style?: React.CSSProperties;
}

export default function RichTextEditor({ value, onChange, placeholder, style }: Props) {
  const quillRef = useRef<ReactQuill>(null);

  const handleChange = (content: string) => {
    onChange?.(content === '<p><br></p>' ? '' : content);
  };

  const imageHandler = () => {
    const input = document.createElement('input');
    input.setAttribute('type', 'file');
    input.setAttribute('accept', 'image/*');
    input.click();

    input.onchange = async () => {
      const file = input.files?.[0];
      if (!file) return;

      const quill = quillRef.current?.getEditor();
      if (!quill) return;

      const range = quill.getSelection(true);

      try {
        const formData = new FormData();
        formData.append('file', file);
        const res = await http.post<{ url: string }>('/upload/image', formData, {
          headers: { 'Content-Type': 'multipart/form-data' },
        });
        const imageUrl = `http://localhost:3001${res.data.url}`;
        quill.insertEmbed(range.index, 'image', imageUrl);
        quill.setSelection(range.index + 1);
      } catch {
        // image upload failed, silently ignore
      }
    };
  };

  const modules = {
    toolbar: {
      container: [
        [{ header: [1, 2, 3, false] }],
        ['bold', 'italic', 'underline', 'strike'],
        [{ color: [] }, { background: [] }],
        [{ list: 'ordered' }, { list: 'bullet' }],
        [{ align: [] }],
        ['blockquote', 'code-block'],
        ['link', 'image'],
        ['clean'],
      ],
      handlers: {
        image: imageHandler,
      },
    },
  };

  const formats = [
    'header', 'bold', 'italic', 'underline', 'strike',
    'color', 'background',
    'list', 'bullet', 'align',
    'blockquote', 'code-block',
    'link', 'image',
  ];

  return (
    <div style={style}>
      <ReactQuill
        ref={quillRef}
        theme="snow"
        value={value || ''}
        onChange={handleChange}
        modules={modules}
        formats={formats}
        placeholder={placeholder || '请输入内容...'}
      />
    </div>
  );
}
