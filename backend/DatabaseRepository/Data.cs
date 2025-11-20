using static Database.Status;

namespace Database;

public class Data
{
    private Dictionary<string, string> _data = new Dictionary<string, string>();
    private int _index = 0;
    
    public static Data CreateDataFormat(List<string> data)
    {
        return new Data(data);
    }

    public Data()
    {
        
    }

    public Data(List<string> data)
    {
        foreach (string item in data)
        {
            _data.Add(item, "EMPTY_SPACE");
        }
    }

    public void Add(string s)
    {
        foreach (KeyValuePair<string, string> pair in _data)
        {
            if (pair.Value.Equals("EMPTY_SPACE"))
            {
                _data[pair.Key] = s;
                return;
            }
        }

        throw new IndexOutOfRangeException();
    }

    public string Next()
    {
        if (_index >= _data.Count) return null;
        return _data[GetNameByIndex(_index++)];
    }

    public string GetDataByString(string s)
    {
        string ans = "";
        if (s.Trim().Equals("")) PrintError($"Data request name is empty");
        else if(!_data.ContainsKey(s)) PrintWarning($"Data with name {s} doesn't exist");
        else ans = _data[s];
        return ans;
    }

    public string GetNameByIndex(int index)
    {
        int i = 0;
        foreach (KeyValuePair<string, string> pair in _data)
        {
            if(i == index) return pair.Key;
            i++;
        }

        throw new IndexOutOfRangeException();
    }

    public string ToString()
    {
        string s = "[";
        string s2 = "[";
        try
        {
            int index = 0;
            bool first = true;
            while (true)
            {
                string name = GetNameByIndex(index);
                string data = GetDataByString(name);
                string a1 = first ? "" : ", ";
                string a2 = first ? "" : ", ";
                a1 += name;
                a2 += data;
                if (name.Length > data.Length)
                {
                    int diff = name.Length - data.Length;
                    for (int i = 0; i < diff; i++)
                    {
                        a2 += " ";
                    }
                }
                else
                {
                    int diff = data.Length - name.Length;
                    for (int i = 0; i < diff; i++)
                    {
                        a1 += " ";
                    }
                }
                s += a1;
                s2 += a2;
                index++;
                first = false;
            }
        }
        catch (Exception e)
        {
            
        }

        s += "]";
        s2 += "]";
        return s + "\n" + s2;
    }

    public Data CopyFormat()
    {
        List<string> names = new List<string>();
        for (int i = 0; i < _data.Count; i++)
        {
            names.Add(GetNameByIndex(i));
        }
        return new Data(names);
    }

    public void SetDataByString(string name, string data)
    {
        _data[name] = data;
    }

    public void ResetIndex()
    {
        _index = 0;
    }
}