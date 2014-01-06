using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;
using System.Data;
using System.Web.Configuration;

namespace GradeBook.Utils
{
    public class DataHandler
    {
        private String conn_string;
        private SqlConnection conn;
        private SqlCommand cmd;
        private SqlDataAdapter da;


        public DataHandler()
        {
            this.conn_string = WebConfigurationManager.ConnectionStrings["ApplicationServices"].ConnectionString;
        }

        public DataHandler(SqlConnection conn)
        {
            this.conn = conn;
        }

        ~DataHandler()
        {
            Stop();
        }

        /// <summary>
        /// Creates a connectino to the database.
        /// </summary>
        /// <returns>An object containing the connection</returns>
        public SqlConnection Connect()
        {
            this.conn = new SqlConnection(conn_string);
            return conn;
        }

        /// <summary>
        /// Sets up the SQL Command and can specify if Stored Proc is involved
        /// </summary>
        /// <param name="Query">The SQL code or query</param>
        /// <param name="StoredProc">Indicates if Query is Stored proc or not</param>
        public void Command(string Query, bool StoredProc)
        {
            cmd = new SqlCommand(Query, conn);

            if (StoredProc)
                cmd.CommandType = CommandType.StoredProcedure;
        }

        /// <summary>
        /// Executes a non returnable query and automatically prepares beforehand
        /// </summary>
        public void ExecNonQuery()
        {
            cmd.ExecuteNonQuery();
        }

        /// <summary>
        /// Executes a query with a return
        /// </summary>
        /// <returns>The result-set</returns>
        public SqlDataReader Exec()
        {
            return cmd.ExecuteReader();
        }

        /// <summary>
        /// Data Binds results to controls
        /// </summary>
        /// <param name="Query">A SQL query</param>
        /// <param name="Table">Name of control to be bound</param>
        /// <returns></returns>
        public DataTable DataBind(string Query, string Table)
        {
            da = new SqlDataAdapter(Query, conn);

            DataSet ds = new DataSet();
            da.Fill(ds, Table);
            return ds.Tables[Table];
        }

        /// <summary>
        /// Adds parameters to Stored proc
        /// </summary>
        /// <param name="Name">Name of the parameter to be added</param>
        /// <param name="Value">Value of the argument to be passed</param>
        public void Add(string Name, string Value)
        {
            cmd.Parameters.AddWithValue(Name, Value);
        }

        /// <summary>
        /// Adds parameters to Stored proc
        /// </summary>
        /// <param name="Name">Name of the parameter to be added</param>
        /// <param name="Value">Value of the argument to be passed</param>
        public void Add(string Name, int Value)
        {
            cmd.Parameters.AddWithValue(Name, Value);
        }

        /// <summary>
        /// Adds parameters to Stored proc
        /// </summary>
        /// <param name="Name">Name of the parameter to be added</param>
        /// <param name="Value">Value of the argument to be passed</param>
        public void Add(string Name, double Value)
        {
            cmd.Parameters.AddWithValue(Name, Value);
        }

        /// <summary>
        /// Adds parameters to Stored proc
        /// </summary>
        /// <param name="Name">Name of the parameter to be added</param>
        /// <param name="Value">Value of the argument to be passed</param>
        public void Add(string Name, bool Value)
        {
            cmd.Parameters.AddWithValue(Name, Value);
        }


        /// <summary>
        /// Adds a return parameter to the Stored Proc
        /// </summary>
        public void AddIntReturn()
        {
            SqlParameter sqlReturn = cmd.Parameters.AddWithValue("@ReturnValue", SqlDbType.Int);
            sqlReturn.Direction = ParameterDirection.ReturnValue;
        }

        /// <summary>
        /// Returns the result of the stored procedure
        /// </summary>
        /// <returns>The value returned after execution of Stored Proc</returns>
        public int ReturnValue()
        {
            return (int)cmd.Parameters["@ReturnValue"].Value;
        }

        /// <summary>
        /// Opens a connection
        /// </summary>
        public void Start()
        {
            conn.Open();
        }

        /// <summary>
        /// Closes a connection
        /// </summary>
        public void Stop()
        {
            conn.Close();
        }
    }
}