defmodule HelloWeb.ProductsUploadLive do
  use HelloWeb, :live_view

  def mount(_params, _session, socket) do
    {
      :ok,
      socket
      |> assign(:page_title, "Products Upload")
      |> assign(:uploaded_file, [])
      |> allow_upload(:sheet, accept: ~w(.xlsx), max_entries: 1)
    }
  end

  def handle_event("validate", _params, socket) do
    IO.inspect(socket.assigns.uploads.sheet.entries, label: "validating entries")
    {:noreply, socket}
  end

  def handle_event("import-file", _params, socket) do
    IO.inspect(socket.assigns.uploads.sheet.entries, label: "entries")

    do_import(socket)
  end

  # ----------------------------------------------------------------------------
  # do_import/1
  # ----------------------------------------------------------------------------
  # This function processes uploaded files.
  #
  # WHAT IS consume_uploaded_entries/3?
  # ------------------------------------
  # Think of it like Array.map() in JavaScript, but specifically for uploads.
  #
  #   JavaScript:  files.map(file => processFile(file))
  #   Elixir:      consume_uploaded_entries(socket, :sheet, &parse_excel_file/2)
  #
  # It loops through each uploaded file and calls your callback function.
  #
  # THE THREE ARGUMENTS:
  # --------------------
  #   1. socket      - The LiveView socket (contains all your assigns/state)
  #   2. :sheet      - The upload name (must match what you used in allow_upload)
  #   3. &parse_excel_file/2 - Your callback function to process each file
  #
  # WHAT DOES & AND /2 MEAN?
  # ------------------------
  #   &parse_excel_file/2 means "reference to the function named parse_excel_file
  #   that takes 2 arguments"
  #
  #   In JavaScript, you'd just write: parseExcelFile (without calling it)
  #   In Elixir, you write: &parse_excel_file/2
  #
  # WHAT DOES IT RETURN?
  # --------------------
  # A list of whatever your callback returns (unwrapped from {:ok, ...}).
  # If parse_excel_file returns {:ok, rows}, you get [rows] in uploaded_results.
  #
  # IMPORTANT SIDE EFFECT:
  # ----------------------
  # After consume_uploaded_entries runs, the temp files are DELETED.
  # You must read/copy the file inside the callback, not after.
  #
  def do_import(socket) do
    # consume_uploaded_entries returns a LIST: [[row1, row2, ...]]

    uploaded_results = consume_uploaded_entries(socket, :sheet, &parse_excel_file/2)
    IO.inspect(uploaded_results, label: "uploaded_results")

    case uploaded_results do
      [] ->
        {:noreply, put_flash(socket, :error, "No File Uploaded")}

      [rows] ->
        {:noreply, assign(socket, :uploaded_file, rows)}
    end
  end

  # ----------------------------------------------------------------------------
  # parse_excel_file/2 - The callback function
  # ----------------------------------------------------------------------------
  # This function is called BY consume_uploaded_entries FOR EACH uploaded file.
  # You don't call this directly - consume_uploaded_entries calls it for you.
  #
  # ARGUMENTS (passed by consume_uploaded_entries, not by you):
  # -----------------------------------------------------------
  #   1. %{path: file_path}
  #      - A map containing the path to the temp file on disk
  #      - Example: %{path: "/tmp/plug-1234/live_view_upload-5678"}
  #      - This is where LiveView saved the uploaded file temporarily
  #      - Use pattern matching to extract: %{path: file_path} gives you file_path
  #
  #   2. entry (a Phoenix.LiveView.UploadEntry struct)
  #      - Contains metadata about the uploaded file
  #      - entry.client_name  → "test_products.xlsx" (original filename)
  #      - entry.client_size  → 8623 (file size in bytes)
  #      - entry.client_type  → "application/vnd..." (MIME type)
  #
  # RETURN VALUE:
  # -------------
  # You MUST return {:ok, result} or {:error, reason}
  #
  # Whatever you put in {:ok, result} gets collected into a list.
  # Example:
  #   - File 1 callback returns {:ok, [row1, row2]}
  #   - File 2 callback returns {:ok, [row3, row4]}
  #   - consume_uploaded_entries returns [[row1, row2], [row3, row4]]
  #
  # WHY {:ok, ...}?
  # ---------------
  # This is an Elixir convention. Many functions return "tagged tuples":
  #   {:ok, value}    → Success! Here's your data
  #   {:error, reason} → Failed! Here's why
  #
  # It's like returning { success: true, data: ... } vs { success: false, error: ... }
  # in JavaScript, but built into the language conventions.
  #
  def parse_excel_file(%{path: file_path}, _entry) do
    case Xlsxir.multi_extract(file_path, 0) do
      {:ok, table_id} ->
        # Get all rows from the Excel sheet
        all_rows = Xlsxir.get_list(table_id)

        # IMPORTANT: Always close the table to free memory
        Xlsxir.close(table_id)

        {:ok, all_rows}

      {:error, reason} ->
        IO.inspect(reason, label: "Error parsing Excel")
        {:error, reason}
    end
  end

  def render(assigns) do
    ~H"""
    <.header>
      Products Upload
      <:subtitle>Upload an Excel file to import products</:subtitle>
    </.header>

    <form phx-change="validate" phx-submit="import-file" class="space-y-4">
      <div class="border-2 border-dashed rounded-lg p-8 text-center">
        <.icon name="hero-document-arrow-up" class="mx-auto h-12 w-12" />
        <p class="mt-2">Upload an Excel file (.xlsx)</p>
        <div class="mt-4">
          <.live_file_input
            upload={@uploads.sheet}
            class="file-input file-input-bordered w-full max-w-xs"
          />
        </div>
      </div>

      <div class="flex justify-center">
        <.button type="submit">
          <.icon name="hero-arrow-up-tray" class="h-4 w-4 mr-2" /> Import Sheet
        </.button>
      </div>
    </form>

    <div :if={@uploaded_file != []} class="mt-8 overflow-x-auto">
      <h2 class="text-lg font-semibold mb-4">Imported Data ({length(@uploaded_file) - 1} rows)</h2>
      <table class="table table-zebra">
        <thead>
          <tr>
            <th :for={header <- hd(@uploaded_file)}>{header}</th>
          </tr>
        </thead>
        <tbody>
          <tr :for={row <- tl(@uploaded_file)}>
            <td :for={cell <- row}>{cell}</td>
          </tr>
        </tbody>
      </table>
    </div>
    """
  end
end
